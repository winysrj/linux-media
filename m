Return-path: <mchehab@pedra>
Received: from mail01.prevas.se ([62.95.78.3]:61930 "EHLO mail01.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1CXKgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 06:36:51 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: SV: OMAP3 isp single-shot
Date: Thu, 24 Mar 2011 11:26:01 +0100
Message-ID: <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se>
In-Reply-To: <4D8B00FA.1090008@maxwell.research.nokia.com>
References: <loom.20110323T141429-496@post.gmane.org> <4D8B00FA.1090008@maxwell.research.nokia.com>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Sakari,

> Daniel Lundborg wrote:
> > Hello,
> 
> Hi Daniel,
> 
> (Cc'ing Laurent.)
> 
> > I am successfully using the gumstix overo board together with a
camera sensor
> > Aptina MT9V034 with the kernel 2.6.35 and patches from
> > http://git.linuxtv.org/pinchartl/media.git (isp6).
> 
> Which branch did you use?

I am using the media-2.6.35-0006-sensors branch which could be found
just a couple of weeks ago. It has the mt9v032 sensor in it. My mt9v034
driver is based on the mt9v032 code.

> 
> > I can use the media-ctl program and yavta to take pictures in
continous
> > streaming mode.
> > 
> > media-ctl -r -l '"mt9034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP
> > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP
CCDC":1[SGRBG10
> > 752x480]
> > 
> > and then:
> > 
> > yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F /dev/video2
> > 
> > 
> > Is there a way to set the ISP in single shot mode?
> 
> Single shot for the ISP is the same as to queue just one buffer. I
> assume the single shot mode is something that the sensor supports?
> 
> > I have tested setting the mt9v034 in snapshot mode and manually
trigger the
> > camera, but the ISP does not send a picture. Is there a way to solve
this with
> > the current OMAP3 isp code?
> 
> Do you get any errors, or you just don't get any video buffers?

This is the output from yavta when I put the sensor in streaming mode:

root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F
/dev/video2

Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
Video format set: width: 752 height: 480 buffer size: 721920
Video format: BA10 (30314142) 752x480
1 buffers requested.
length: 721920 offset: 0
Buffer 0 mapped at address 0x4014d000.
0 (0) [-] 0 721920 bytes 65877.098848 1300958239.111966 0.001 fps
Captured 1 frames in 0.000062 seconds (16129.032258 fps,
11643870967.741936 B/s).
1 buffers released.

And the output when putting the sensor in snapshot mode:

root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F
/dev/video2

Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
Video format set: width: 752 height: 480 buffer size: 721920
Video format: BA10 (30314142) 752x480
1 buffers requested.
length: 721920 offset: 0
Buffer 0 mapped at address 0x4014d000.

And it freezes. I can stop yavta with CTRL+C.

To put the sensor in snapshot/shutter mode I set the ext_trig = 1 in the
platform_data structure in my board file.

struct mt9v034_platform_data {
	unsigned int clk_pol:1;
	unsigned int ext_trig:1;

	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int
rate);
};

And in the s_stream I set the chip_control register for the MT9V034
sensor to:

static int mt9v034_s_stream(struct v4l2_subdev *subdev, int enable)
{
  struct mt9v034 *mt9v034 = to_mt9v034(subdev);
  const u16 chip_clear = mt9v034->pdata->ext_trig? 0x0100 : 0;
  const u16 chip_set = mt9v034->pdata->ext_trig? 0x18 :
MT9V034_CHIP_CONTROL_MASTER_MODE | MT9V034_CHIP_CONTROL_DOUT_ENABLE |
MT9V034_CHIP_CONTROL_SEQUENTIAL;
  struct i2c_client *client = v4l2_get_subdevdata(subdev);
  struct v4l2_mbus_framefmt *format = &mt9v034->format;
  struct v4l2_rect *crop = &mt9v034->crop;
  unsigned int hratio;
  unsigned int vratio;
  int ret;

  if (!enable) {
    ret = mt9v034_set_chip_control(mt9v034, chip_clear, chip_set);
    if (ret < 0)
      return ret;

    return __mt9v034_set_power(mt9v034, 0);
  }

  ret = __mt9v034_set_power(mt9v034, 1);
  if (ret < 0)
    return ret;

  /* Configure the window size and row/column bin */
  hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
  vratio = DIV_ROUND_CLOSEST(crop->height, format->height);

  ret = mt9v034_write(client, MT9V034_READ_MODE,
        (hratio - 1) << MT9V034_READ_MODE_ROW_BIN_SHIFT |
        (vratio - 1) << MT9V034_READ_MODE_COLUMN_BIN_SHIFT);
  if (ret < 0)
    return ret;

  ret = mt9v034_write(client, MT9V034_COLUMN_START, crop->left);
  if (ret < 0)
    return ret;

  ret = mt9v034_write(client, MT9V034_ROW_START, crop->top);
  if (ret < 0)
    return ret;

  ret = mt9v034_write(client, MT9V034_WINDOW_WIDTH, crop->width);
  if (ret < 0)
    return ret;

  ret = mt9v034_write(client, MT9V034_WINDOW_HEIGHT, crop->height);
  if (ret < 0)
    return ret;

  /* Disable the noise correction algorithm and restore the controls. */
  ret  = mt9v034_write(client, MT9V034_ROW_NOISE_CORR_CONTROL, 0);
  if (ret < 0)
    return ret;

  v4l2_ctrl_handler_setup(&mt9v034->ctrls);
  
  ret = mt9v034_set_chip_control(mt9v034, chip_clear, chip_set);
  
  return ret;
}

I can see on the oscilloscope that the sensor is sending something when
I trigger it, but no picture is received..

> As the sensor works in streaming mode, are you sure it outputs the
image
> of correct size in the single shot mode?

The sensor has the same output in streaming and single shot mode.

> 
> > I have before successfully used the isp parts from the Nokia N900
project..
> 
> This is nice to hear! :-)
> 
> Regards,
> 
> -- 
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com


Thanks,

Daniel Lundborg
daniel.lundborg@prevas.se


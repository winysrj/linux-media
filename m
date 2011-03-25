Return-path: <mchehab@pedra>
Received: from mail01.prevas.se ([62.95.78.3]:47174 "EHLO mail01.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1CYNU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 09:20:29 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Re: OMAP3 isp single-shot
Date: Fri, 25 Mar 2011 14:10:28 +0100
Message-ID: <CA7B7D6C54015B459601D68441548157C5A3B3@prevas1.prevas.se>
In-Reply-To: <201103241135.06025.laurent.pinchart@ideasonboard.com>
References: <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se> <201103241135.06025.laurent.pinchart@ideasonboard.com>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	<linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> Hi Daniel,
> 
> On Thursday 24 March 2011 11:26:01 Daniel Lundborg wrote:
> > > Daniel Lundborg wrote:
> > > >
> > > > I am successfully using the gumstix overo board together with a
camera
> > > > sensor Aptina MT9V034 with the kernel 2.6.35 and patches from
> > > > http://git.linuxtv.org/pinchartl/media.git (isp6).
> > > 
> > > Which branch did you use?
> > 
> > I am using the media-2.6.35-0006-sensors branch which could be found
> > just a couple of weeks ago. It has the mt9v032 sensor in it. My
mt9v034
> > driver is based on the mt9v032 code.
> 
> Now that the OMAP3 ISP driver is on its way to mainline, I've
reorganized the 
> repository. You can use the media-2.6.38-0002-sensors branch for
2.6.38.
> 
> > > > I can use the media-ctl program and yavta to take pictures in
continous
> > > > streaming mode.
> > > > 
> > > > media-ctl -r -l '"mt9034 3-0048":0->"OMAP3 ISP CCDC":0[1],
"OMAP3 ISP
> > > > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > > > media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP
> > > > CCDC":1[SGRBG10 752x480]
> > > > 
> > > > and then:
> > > > 
> > > > yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F /dev/video2
> > > > 
> > > > Is there a way to set the ISP in single shot mode?
> > > 
> > > Single shot for the ISP is the same as to queue just one buffer. I
assume
> > > the single shot mode is something that the sensor supports?
> > > 
> > > > I have tested setting the mt9v034 in snapshot mode and manually
trigger
> > > > the camera, but the ISP does not send a picture. Is there a way
to solve
> > > > this with the current OMAP3 isp code?
> > > 
> > > Do you get any errors, or you just don't get any video buffers?
> > 
> > This is the output from yavta when I put the sensor in streaming
mode:
> > 
> > root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1
-F
> > /dev/video2
> > 
> > Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> > Video format set: width: 752 height: 480 buffer size: 721920
> > Video format: BA10 (30314142) 752x480
> > 1 buffers requested.
> > length: 721920 offset: 0
> > Buffer 0 mapped at address 0x4014d000.
> > 0 (0) [-] 0 721920 bytes 65877.098848 1300958239.111966 0.001 fps
> > Captured 1 frames in 0.000062 seconds (16129.032258 fps,
> > 11643870967.741936 B/s).
> > 1 buffers released.
> > 
> > And the output when putting the sensor in snapshot mode:
> > 
> > root@overo:~/yavta# ./yavta -f SGRBG10 -s 752x480 -n 1 --capture=1
-F
> > /dev/video2
> > 
> > Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> > Video format set: width: 752 height: 480 buffer size: 721920
> > Video format: BA10 (30314142) 752x480
> > 1 buffers requested.
> > length: 721920 offset: 0
> > Buffer 0 mapped at address 0x4014d000.
> > 
> > And it freezes. I can stop yavta with CTRL+C.
> 
> Have you tried to trigger the sensor multiple times in a row ?
> 
> > To put the sensor in snapshot/shutter mode I set the ext_trig = 1 in
the
> > platform_data structure in my board file.
> > 
> > struct mt9v034_platform_data {
> > 	unsigned int clk_pol:1;
> > 	unsigned int ext_trig:1;
> > 
> > 	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int
rate);
> > };
> > 
> > And in the s_stream I set the chip_control register for the MT9V034
> > sensor to:
> > 
> > static int mt9v034_s_stream(struct v4l2_subdev *subdev, int enable)
> > {
> >   struct mt9v034 *mt9v034 = to_mt9v034(subdev);
> >   const u16 chip_clear = mt9v034->pdata->ext_trig? 0x0100 : 0;
> >   const u16 chip_set = mt9v034->pdata->ext_trig? 0x18 :
> > MT9V034_CHIP_CONTROL_MASTER_MODE | MT9V034_CHIP_CONTROL_DOUT_ENABLE
|
> > MT9V034_CHIP_CONTROL_SEQUENTIAL;
> >   struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >   struct v4l2_mbus_framefmt *format = &mt9v034->format;
> >   struct v4l2_rect *crop = &mt9v034->crop;
> >   unsigned int hratio;
> >   unsigned int vratio;
> >   int ret;
> > 
> >   if (!enable) {
> >     ret = mt9v034_set_chip_control(mt9v034, chip_clear, chip_set);
> >     if (ret < 0)
> >       return ret;
> > 
> >     return __mt9v034_set_power(mt9v034, 0);
> >   }
> > 
> >   ret = __mt9v034_set_power(mt9v034, 1);
> >   if (ret < 0)
> >     return ret;
> > 
> >   /* Configure the window size and row/column bin */
> >   hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
> >   vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
> > 
> >   ret = mt9v034_write(client, MT9V034_READ_MODE,
> >         (hratio - 1) << MT9V034_READ_MODE_ROW_BIN_SHIFT |
> >         (vratio - 1) << MT9V034_READ_MODE_COLUMN_BIN_SHIFT);
> >   if (ret < 0)
> >     return ret;
> > 
> >   ret = mt9v034_write(client, MT9V034_COLUMN_START, crop->left);
> >   if (ret < 0)
> >     return ret;
> > 
> >   ret = mt9v034_write(client, MT9V034_ROW_START, crop->top);
> >   if (ret < 0)
> >     return ret;
> > 
> >   ret = mt9v034_write(client, MT9V034_WINDOW_WIDTH, crop->width);
> >   if (ret < 0)
> >     return ret;
> > 
> >   ret = mt9v034_write(client, MT9V034_WINDOW_HEIGHT, crop->height);
> >   if (ret < 0)
> >     return ret;
> > 
> >   /* Disable the noise correction algorithm and restore the
controls. */
> >   ret  = mt9v034_write(client, MT9V034_ROW_NOISE_CORR_CONTROL, 0);
> >   if (ret < 0)
> >     return ret;
> > 
> >   v4l2_ctrl_handler_setup(&mt9v034->ctrls);
> > 
> >   ret = mt9v034_set_chip_control(mt9v034, chip_clear, chip_set);
> > 
> >   return ret;
> > }
> > 
> > I can see on the oscilloscope that the sensor is sending something
when
> > I trigger it, but no picture is received..
> 
> "something" is a bit vague, can you check the hsync/vsync signals and
make 
> sure they're identical in both modes ?

I have now tested this and I can say that I am having problems
triggering the sensor. I wrongly thought I was triggering the sensor
with my other driver correctly, but that was not the case.

What I want is to put the Omap ISP to generate a signal (CAM_WEN) to
make the camera sensor take a picture.

In my working mt9v034 driver which is using kernel 2.6.31-rc7 with the
patches from <http://gitorious.org/omap3camera/mainline/commits/slave> I
set the ISP to this on power on:

  isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
0x9a1b63ff, 0x98036000);  // Set CAM_GLOBAL_RESET pin as output, enable
shutter, set DIVC = 216
  isp_reg_and(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_SHUT_DELAY, 0xfe000000);  // Set no shutter delay
  isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_SHUT_LENGTH, 0xfe000000, 0x000003e8);  // Set shutter signal
length to 1000 (=> 1000 * 1/216MHz * 216 = 1 ms)
  isp_reg_and_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN,
ISP_TCTRL_GRESET_LENGTH, 0xfe000000, 0x000003e8);  // Set shutter signal
length to 1000 (=> 1000 * 1/216MHz * 216 = 1 ms)
  isp_reg_and(isp_ccdc_dev, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG,
~ISPCCDC_LSC_ENABLE);  // Make sure you disable LSC

And when I want to take a picture I do:

  isp_reg_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
0x00e00000);  // Enable shutter (SHUTEN bit = 1)
  isp_reg_or(vdev->cam->isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
0x20000000);  // Start generation of CAM_GLOBAL_RESET signal (GRESETEN
bit = 1)
  
When I try to do this in the newer driver I manage to generate a pulse
on the CAM_WEN pin, but no VSYNC, HSYNC or data is transmitted.

Am I missing something?

> 
> > > As the sensor works in streaming mode, are you sure it outputs the
image
> > > of correct size in the single shot mode?
> > 
> > The sensor has the same output in streaming and single shot mode.
> 
> -- 

Regards,

Daniel Lundborg

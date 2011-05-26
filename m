Return-path: <mchehab@pedra>
Received: from mail01.prevas.se ([62.95.78.3]:24249 "EHLO mail01.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1EZNGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 09:06:19 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: SV: omap3isp - H3A auto white balance
Date: Thu, 26 May 2011 15:06:17 +0200
Message-ID: <CA7B7D6C54015B459601D68441548157C5A3FE@prevas1.prevas.se>
In-Reply-To: <201105261301.32159.laurent.pinchart@ideasonboard.com>
References: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se> <201105261301.32159.laurent.pinchart@ideasonboard.com>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> Hi Daniel,
> 
> On Thursday 26 May 2011 10:57:39 Daniel Lundborg wrote:
> > 
> > Hello,
> > 
> > I am developing a camera sensor driver for the Aptina MT9V034. I am
only
> > using it in snapshot mode and I can successfully trigger the sensor
and
> > receive pictures using the latest omap3isp driver from
> > git://linuxtv.org/pinchartl/media.git branch omap3isp-next-sensors
with
> > kernel 2.6.38.
> > 
> > I configure the sensor with media-ctl:
> > 
> > media-ctl -r -l '"mt9v034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP
> > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > 
> > media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP
> > CCDC":1[SGRBG10 752x480]'
> > 
> > And take pictures with yavta:
> > 
> > ./yavta -f SGRBG10 -s 752x480 -n 6 --capture=6 -F /dev/video2
> > 
> > My trouble is that I am always receiving whiter pictures when I wait
a
> > moment before triggering the sensor to take a picture. If I take
several
> > pictures in a row with for instance 20 ms between them, they all
look
> > ok. But if I wait for 100 ms the picture will get much whiter.
> > 
> > I have turned off auto exposure and auto gain in the sensor and the
> > LED_OUT signal always have the same length (in this case 8 msec).
> 
> I assume you've measured it with a scope ?
> 
> Try disabling black level calibration and row noise correction as
well. Please 
> also double-check that AEC and AGC are disabled. I've had a similar
issue with 
> an MT9V032 sensor, where a bug in the driver enabled AEC/AGC instead
of 
> disabling them.

The register on 0xaf (MT9V034_AGC_AEC_ENABLE) is set to 0 and is 0 when
I read from it.
bit 0 - AEC enable context A, bit 1 - AGC enable context A, bit 8 - AEC
enable context B, bit 9 - AGC enable context B 

The register on 0x47 (MT9V034_BL_CALIB_CTRL) is set to 0 and is 0 when I
read from it.
bit 0 - (1 = override with programmed values, 0 = normal operation), bit
7:5 - Frames to average over

The register on 0x70 (MT9V034_ROW_NOISE_CORR_CONTROL) is set to 0 and is
0 when I read from it.
bit 0 - enable noise correction context A , bit 1 - Use black level avg
context A, bit 8 - enable noise correction context B, bit 9 - Use black
level avg context B

I measure the signals with a scope and the LED_OUT signal is always 8
msec when triggered. 

Code from my mt9v034.c:

#define   MT9V034_CHIP_CONTROL_SNAPSHOT_MODE (3 << 3)
#define 	MT9V034_CHIP_CONTROL_DOUT_ENABLE	(1 << 7)
#define 	MT9V034_CHIP_CONTROL_SEQUENTIAL		(1 << 8)
#define   MT9V034_CHIP_CONTROL_RESERVED (1 << 9)

static int mt9v034_power_on(struct mt9v034 *mt9v034)
{
	if (mt9v034->pdata->set_clock) {
		mt9v034->pdata->set_clock(&mt9v034->subdev, 24000000);
	}

  msleep(1);

  mt9v034->pdata->configure(&mt9v034->subdev);

  msleep(1);

  mt9v034->pdata->reset();
  
  usleep_range(1000, 2000);

  mt9v034_configure(&mt9v034->subdev);
}

static int mt9v034_configure(struct v4l2_subdev *subdev)
{
	struct i2c_client *client = v4l2_get_subdevdata(subdev);
	struct mt9v034 *mt9v034 = to_mt9v034(subdev);
	int ret;
  
  ret = mt9v034_set_chip_control(mt9v034, MT9V034_CHIP_CONTROL_RESERVED,
0);  // Clear bit 9 for normal operation
  if (ret < 0)
    return ret;
  
	v4l2_ctrl_handler_setup(&mt9v034->ctrls);
  
  ret = mt9v034_write(client, MT9V034_AEC_AGC_ENABLE_A_B,
mt9v034->aec_agc);  // Set AEC (Automatic Exposure Control) and AGC
(Automatic Gain Control)
  if (ret < 0)
    return ret;

  ret = mt9v034_write(client,
MT9V034_COARSE_TOTAL_SHUTTER_WIDTH_CONTEXT_A, 243); // Set "Total
shutter width" register so exposure time is set
  if (ret < 0)
    return ret;

    
  ret = mt9v034_write(client,  MT9V034_ANALOG_GAIN_CONTEXT_A, 16); //
Set "Analog gain" register so gain is set
  if (ret < 0)
    return ret;
    
  msleep(1);
  
	ret = mt9v034_write(client, MT9V034_BL_CALIB_CTRL, 0);  //
Disable black calibration
	if (ret < 0)
		return ret;
  
	ret = mt9v034_write(client, MT9V034_ROW_NOISE_CORR_CONTROL, 0);
// Disable row noise correction
	if (ret < 0)
		return ret;

  msleep(20);
  
  ret = mt9v034_set_chip_control(mt9v034, MT9V034_CHIP_CONTROL_RESERVED,
MT9V034_CHIP_CONTROL_SNAPSHOT_MODE);  // Clear bit 9 for normal
operation and set to snapshot mode
  if (ret < 0)
    return ret;
    
  return 0;
}

And from my board-overo.c file:

void overo_camera_configure(struct v4l2_subdev *subdev)
{
	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);
  
  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL,
~0x9a1b63ff, 0x98036000); // Set CAM_GLOBAL_RESET pin as output, enable
shutter, set DIVC = 216
  isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_DELAY,
0x01ffffff);  // Set no shutter delay  
  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_SHUT_LENGTH,
0x01ffffff, 0x000003e8); // Set shutter signal length to 1000 (=> 1000 *
1/216MHz * 216 = 1 ms)
  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_GRESET_LENGTH,
0x01ffffff, 0x000003e8); // Set CAM_GLOBAL_RESET signal length to 1000
(=> 1000 * 1/216MHz * 216 = 1 ms)
}

static void overo_camera_take_picture(struct v4l2_subdev *subdev)
{
	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);
  
  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0,
0x00e00000);  // Enable shutter (SHUTEN bit = 1)
  isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_TCTRL_CTRL, 0,
0x20000000);  // Start generation of CAM_GLOBAL_RESET signal (GRESETEN
bit = 1)
}

static void overo_camera_set_clock(struct v4l2_subdev *subdev, unsigned
int rate)
{
	struct isp_device *isp =
v4l2_dev_to_isp_device(subdev->v4l2_dev);

	isp->platform_cb.set_xclk(isp, rate, OVERO_CAMERA_XCLK);
}

static void overo_camera_reset(void)
{
  DPRINT("overo_camera_reset");
  
  gpio_set_value(OVERO_GPIO_CAM_RESET, 0);
  
  msleep(1);
  
  gpio_set_value(OVERO_GPIO_CAM_RESET, 1);
}

> 
> Do you have a light source connected to the LED_OUT signal ? If so,
can you 
> try disabling it and using a constant light source ?

No I'm not using the LED_OUT signal other than measuring the exposure
time at this point.

> 
> > Why would the pictures become whiter if I wait a moment before
taking a
> > picture?
> >
> > If I set the sensor in streaming mode all pictures look like they
> > should.
> > 
> > Could there be something with the H3A auto white balance or auto
exposure?
> 
> The OMAP3 ISP isn't able to apply any H3A algorithm to the images by
itself. 
> The H3A hardware support only computes statistics, and a userspace
application 
> then needs to compute parameters (such as exposure time and gains)
based on 
> the statistics, and apply them to the hardware. As yavta doesn't
include H3A 
> algorithms, the differences in picture brightness can only come from
the 
> sensor.
> 
> -- 
> Regards,
> 
> Laurent Pinchart

Regards,

Daniel Lundborg

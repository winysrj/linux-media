Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:46872 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3B0JFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 04:05:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [REVIEW PATCH 01/11] s2255: convert to the control framework.
Date: Wed, 27 Feb 2013 10:05:17 +0100
Cc: linux-media@vger.kernel.org, Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl> <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com> <512D355F.2010309@gmail.com>
In-Reply-To: <512D355F.2010309@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302271005.17713.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 26 February 2013 23:21:19 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 02/26/2013 06:35 PM, Hans Verkuil wrote:
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index dcd6374..f6ba2fc 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -146,6 +146,10 @@ enum v4l2_colorfx {
> >    * of controls. We reserve 16 controls for this driver. */
> >   #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
> 
> I couldn't find a patch adding this hunk in my e-mail archive so I'm
> commenting here. Shouldn't V4L2_CID_USER_MEYE_BASE start at a higher value,
> e.g. (V4L2_CID_USER_BASE + 0x1010) to account for drivers that already
> use private controls ? There is couple of them with a few control IDs
> starting at V4L2_CID_USER_BASE.

Private controls always had overlapping IDs. During one of the mini-summits
last year we decided to change that so they all had their own ID. The meye
driver is one of the first to have a proper range defined, eventually all
other drivers that have private controls will be added there. That includes
those you found with grep.

So give me time and it will all be fixed :-)

Regards,

	Hans

> 
> $ git grep V4L2_CID_USER_BASE
> 
> drivers/media/i2c/mt9p031.c:#define V4L2_CID_BLC_AUTO 
> (V4L2_CID_USER_BASE | 0x1002)
> drivers/media/i2c/mt9p031.c:#define V4L2_CID_BLC_TARGET_LEVEL 
> (V4L2_CID_USER_BASE | 0x1003)
> drivers/media/i2c/mt9p031.c:#define V4L2_CID_BLC_ANALOG_OFFSET 
> (V4L2_CID_USER_BASE | 0x1004)
> drivers/media/i2c/mt9p031.c:#define V4L2_CID_BLC_DIGITAL_OFFSET 
> (V4L2_CID_USER_BASE | 0x1005)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_TEST_PATTERN_COLOR 
> (V4L2_CID_USER_BASE | 0x1001)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_BLACK_LEVEL_AUTO 
> (V4L2_CID_USER_BASE | 0x1002)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_BLACK_LEVEL_OFFSET 
> (V4L2_CID_USER_BASE | 0x1003)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_BLACK_LEVEL_CALIBRATE 
> (V4L2_CID_USER_BASE | 0x1004)
> drivers/media/i2c/mt9v032.c:#define V4L2_CID_TEST_PATTERN_COLOR 
> (V4L2_CID_USER_BASE | 0x1001)
> drivers/media/platform/mem2mem_testdev.c:#define 
> V4L2_CID_TRANS_TIME_MSEC       (V4L2_CID_USER_BASE + 0x1000)
> drivers/media/platform/mem2mem_testdev.c:#define V4L2_CID_TRANS_NUM_BUFS 
>                 (V4L2_CID_USER_BASE + 0x1001)
> drivers/media/platform/vivi.c:#define VIVI_CID_CUSTOM_BASE 
> (V4L2_CID_USER_BASE | 0xf000)
> drivers/media/usb/cpia2/cpia2_v4l.c:#define CPIA2_CID_USB_ALT 
> (V4L2_CID_USER_BASE | 0xf000)
> drivers/media/usb/pwc/pwc-v4l.c:#define PWC_CID_CUSTOM(ctrl) 
> ((V4L2_CID_USER_BASE | 0xf000) + custom_ ## ctrl)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_ISIF_CID_CRGAIN             (V4L2_CID_USER_BASE | 0xa001)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_ISIF_CID_CGRGAIN            (V4L2_CID_USER_BASE | 0xa002)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_ISIF_CID_CGBGAIN            (V4L2_CID_USER_BASE | 0xa003)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_ISIF_CID_CBGAIN             (V4L2_CID_USER_BASE | 0xa004)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_ISIF_CID_GAIN_OFFSET        (V4L2_CID_USER_BASE | 0xa005)
> drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h:#define 
> VPFE_CID_DPCM_PREDICTOR          (V4L2_CID_USER_BASE | 0xa006)
> include/uapi/linux/v4l2-controls.h:#define V4L2_CID_USER_BASE 
> V4L2_CID_BASE
> include/uapi/linux/v4l2-controls.h:#define V4L2_CID_USER_MEYE_BASE 
>                  (V4L2_CID_USER_BASE + 0x1000)
> 
> And also
> 
> $ git grep V4L2_CTRL_CLASS_CAMERA
> 
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_GAIN_RED 
> (V4L2_CTRL_CLASS_CAMERA | 0x1001)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_GAIN_GREEN_RED 
> (V4L2_CTRL_CLASS_CAMERA | 0x1002)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_GAIN_GREEN_BLUE 
> (V4L2_CTRL_CLASS_CAMERA | 0x1003)
> drivers/media/i2c/mt9t001.c:#define V4L2_CID_GAIN_BLUE 
> (V4L2_CTRL_CLASS_CAMERA | 0x1004)
> drivers/media/i2c/s5k6aa.c:#define V4L2_CID_RED_GAIN 
> (V4L2_CTRL_CLASS_CAMERA | 0x1001)
> drivers/media/i2c/s5k6aa.c:#define V4L2_CID_GREEN_GAIN 
> (V4L2_CTRL_CLASS_CAMERA | 0x1002)
> drivers/media/i2c/s5k6aa.c:#define V4L2_CID_BLUE_GAIN 
> (V4L2_CTRL_CLASS_CAMERA | 0x1003)
> 
> > +/* The base for the s2255 driver controls.
> > + * We reserve 8 controls for this driver. */
> > +#define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1010)
> > +
> 
> --
> 
> Regards,
> Sylwester
> 

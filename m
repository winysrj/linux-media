Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3005 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934017AbeALIrQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 03:47:16 -0500
Date: Fri, 12 Jan 2018 10:45:43 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>
Subject: Re: [PATCH] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180112084543.53gw5rtf6oxosuep@paasikivi.fi.intel.com>
References: <1515682059-17832-1-git-send-email-andy.yeh@intel.com>
 <20180111212527.tctm7uuqenlrdbta@kekkonen.localdomain>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4DEF46@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D4DEF46@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Fri, Jan 12, 2018 at 08:18:50AM +0000, Yeh, Andy wrote:
> Thanks Sakari to remind.
> Since I would like to attach some snips from the datasheets. But blocked, I will re-edit to plain table and hope it could be understood.

Please wrap the lines at 80 characters.

> 
> Regards, Andy
> 
> From: Yeh, Andy 
> Sent: Friday, January 12, 2018 3:31 PM
> To: 'Sakari Ailus' <sakari.ailus@linux.intel.com>
> Cc: 'linux-media@vger.kernel.org' <linux-media@vger.kernel.org>; AlanX Chiang (alanx.chiang@intel.com) <alanx.chiang@intel.com>; JasonX Z Chen (jasonx.z.chen@intel.com) <jasonx.z.chen@intel.com>
> Subject: RE: [PATCH] media: imx258: Add imx258 camera sensor driver
> 
> Hi Sakari,
> 
> Thanks for the review comments.  Please check first then I will update patch accordingly.
> 
> > +       usleep_range(1000, 2000);
> 
> You are right. This should be removed since delayed in ACPI power on
> sequence.
> https://chromium-review.googlesource.com/c/chromiumos/third_party/coreboot/+/826746/5/src/mainboard/google/poppy/variants/nautilus/include/variant/acpi/mipi_camera.asl#402
>             \_SB.PCI0.I2C2.CAM0.CRST(1)             Sleep(5) (could be
> less so it could be adjusted in coreboot then for shorter launch time. )

Ack.

> 
> > +       /* stream off */
> > +       ret = imx258_write_reg(imx258, IMX258_REG_MODE_SELECT,
> > +                                           IMX258_REG_VALUE_08BIT, IMX258_MODE_STANDBY);
> > I don't think it should be possible that the sensor was streaming here. If
> > it was, something must have been really wrong.
> 
> Sensor datasheet claimed before updating register and streaming, need do
> SW standby. However Sony implements the function with single bit.
> (different from OVT) So I will change the comment to "software standby"
> to replace "stream off" to clarify the purpose.
> 
> Address: 0x0100
> Value:
> 0: software standby
> 1: streaming

Yes, this is true. But the sensor is already in software standby mode here,
isn't it?

...

> And from T6~T7, per the profiling data on DUT, the duration is always
> longer than 25ms (removed the manual delay) while loading all required
> register lists. I would still prefer to keep a 1~2ms delay range before
> streaming on for safety purpose.

Fair enough; to be on the safe side, you indeed need the 12 ms delay here.

> 
> > +static int imx258_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
> > +{
> > +       /*
> > +       * Sony: The 1st frame is ok when set from SW standby to streaming.
> > +       */
> > +       *frames = 0;
> 
> > If that's the case, then you can drop g_skip_frames callback altogether..
> 
> If remove g_skip_frames callback, it implies always 0 when user queries.
> I would like to keep the flexibly if we will need change the skip_frames
> value. How do you think?

If it turns out the sensor needs this, then you can re-introduce the
function. Please remove it now.

> 
> > +       case V4L2_CID_GAIN:
> > +                   /* Todo */
> > +                   break;
> > +       case V4L2_CID_TEST_PATTERN:
> > +                   /* Todo */
> > If the control isn't implemented, I suggest to remove it from the driver altogether, or alternatively implement it.
> > The GAIN control should likely be DIGITAL_GAIN instead, right?
> 
> You are right. Will remove them first. We are almost done (DIGITAL_GAIN)
> and will submit separately.

Ack.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60666 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934382AbdKQOgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:36:46 -0500
Subject: Re: [RFCv1 PATCH 1/6] v4l2-ctrls: v4l2_ctrl_add_handler: add
 from_other_dev
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
 <20171113143408.19644-2-hverkuil@xs4all.nl>
 <20171117114112.20bb751d@vento.lan>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dca07a2b-c731-f438-e2d6-ba9bd68c4a31@xs4all.nl>
Date: Fri, 17 Nov 2017 15:36:43 +0100
MIME-Version: 1.0
In-Reply-To: <20171117114112.20bb751d@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/11/17 14:41, Mauro Carvalho Chehab wrote:
> Em Mon, 13 Nov 2017 15:34:03 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add a 'bool from_other_dev' argument: set to true if the two
>> handlers refer to different devices (e.g. it is true when
>> inheriting controls from a subdev into a main v4l2 bridge
>> driver).
>>
>> This will be used later when implementing support for the
>> request API since we need to skip such controls.
>>
>> TODO: check drivers/staging/media/imx/imx-media-fim.c change.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/dvb-frontends/rtl2832_sdr.c        |  5 +--
>>  drivers/media/pci/bt8xx/bttv-driver.c            |  2 +-
>>  drivers/media/pci/cx23885/cx23885-417.c          |  2 +-
>>  drivers/media/pci/cx88/cx88-blackbird.c          |  2 +-
>>  drivers/media/pci/cx88/cx88-video.c              |  2 +-
>>  drivers/media/pci/saa7134/saa7134-empress.c      |  4 +--
>>  drivers/media/pci/saa7134/saa7134-video.c        |  2 +-
>>  drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c      |  3 +-
>>  drivers/media/platform/rcar_drif.c               |  2 +-
>>  drivers/media/platform/soc_camera/soc_camera.c   |  3 +-
>>  drivers/media/platform/vivid/vivid-ctrls.c       | 42 ++++++++++++------------
>>  drivers/media/usb/cx231xx/cx231xx-417.c          |  2 +-
>>  drivers/media/usb/cx231xx/cx231xx-video.c        |  4 +--
>>  drivers/media/usb/msi2500/msi2500.c              |  2 +-
>>  drivers/media/usb/tm6000/tm6000-video.c          |  2 +-
>>  drivers/media/v4l2-core/v4l2-ctrls.c             | 11 ++++---
>>  drivers/media/v4l2-core/v4l2-device.c            |  3 +-
>>  drivers/staging/media/imx/imx-media-dev.c        |  2 +-
>>  drivers/staging/media/imx/imx-media-fim.c        |  2 +-
>>  include/media/v4l2-ctrls.h                       |  4 ++-
> 
> You forgot to update Documentation/media/kapi/v4l2-controls.rst.
> 
>>  21 files changed, 56 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
>> index c6e78d870ccd..6064d28224e8 100644
>> --- a/drivers/media/dvb-frontends/rtl2832_sdr.c
>> +++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
>> @@ -1394,7 +1394,8 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
>>  	case RTL2832_SDR_TUNER_E4000:
>>  		v4l2_ctrl_handler_init(&dev->hdl, 9);
>>  		if (subdev)
>> -			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler, NULL);
>> +			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler,
>> +					      NULL, true);
> 
> Changing all drivers to tell if a control belongs to a subdev or not
> seems weird. I won't doubt that people may get it wrong and fill it
> with a wrong value.
> 
> IMHO, it would be better, instead, to pass some struct to the function
> that would allow the function to check if the device is a subdev
> or not.
> 
> For example, we could do:
> 
> int v4l2_ctrl_subdev_add_handler(struct v4l2_ctrl_handler *hdl,
> 				 struct v4l2_subdev *sd,
>                         	 v4l2_ctrl_filter filter);
> 
> That should be used for all subdev controls. Internally, such
> function would be using:
> 	sd->control_handler
> as the add parameter for v4l2_ctrl_add_handler().
> 
> I would also try to do the same for devices: have a
> v4l2_ctrl_dev_add_handler() that would take a struct v4l2_dev, and
> make v4l2_ctrl_add_handler() a static function inside v4l2-ctrls.c.
> 
> This way, we should avoid the risk of wrong usages.

You can ignore this patch. I'm not happy with it either, and I'm pretty
sure it is not needed for the stateless codec use-case.

Regards,

	Hans

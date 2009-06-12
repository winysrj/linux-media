Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:36944 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZFLBxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 21:53:21 -0400
Received: by pzk17 with SMTP id 17so282010pzk.33
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 18:53:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906111413250.5625@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
	 <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
	 <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
	 <Pine.LNX.4.64.0906111413250.5625@axis700.grange>
Date: Fri, 12 Jun 2009 10:53:20 +0900
Message-ID: <5e9665e10906111853w1af3aec9wcf647a280d3635e7@mail.gmail.com>
Subject: Re: [PATCH 3/4] soc-camera: add support for camera-host controls
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

So let's assume that camera interface device can process
V4L2_CID_SHARPNESS and even external camera device can process that,
then according to your patch both of camera interface and external
camera device can be issued to process V4L2_CID_SHARPNESS which I
guess will make image sharpened twice. Am I getting the patch right?

If I'm getting right, it might be better to give user make a choice
through platform data or some sort of variable which can make a choice
between camera interface and camera device to process the CID. It
could be just in aspect of manufacturer mind, we do love to make a
choice between same features in different devices in easy way. So
never mind if my idea is not helpful making your driver elegant :-)
Cheers,

Nate


On Thu, Jun 11, 2009 at 9:16 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> On Thu, 11 Jun 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hello Guennadi,
>>
>> It's a very interesting patch. Actually some camera interfaces support
>> for various image effects and I was wondering how to use them in SoC
>> camera subsystem.
>>
>> But here is a question. Is it possible to make a choice with the same
>> CID between icd and ici? I mean, if both of camera interface and
>> camera device are supporting for same CID how can user select any of
>> them to use? Sometimes, some image effects supported by camera
>> interface are not good so I want to use the same effect supported by
>> external camera ISP device.
>>
>> I think, it might be possible but I can't see how.
>
>> > @@ -681,9 +698,16 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
>> >        struct soc_camera_file *icf = file->private_data;
>> >        struct soc_camera_device *icd = icf->icd;
>> >        struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>> > +       int ret;
>> >
>> >        WARN_ON(priv != file->private_data);
>> >
>> > +       if (ici->ops->set_ctrl) {
>> > +               ret = ici->ops->set_ctrl(icd, ctrl);
>> > +               if (ret != -ENOIOCTLCMD)
>> > +                       return ret;
>> > +       }
>> > +
>> >        return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_ctrl, ctrl);
>> >  }
>
> Should be easy to see in the patch. Host's s_ctrl is called first. It can
> return -ENOIOCTLCMD then sensor's control will be called too. Ot the host
> may choose to call sensor's control itself, which, however, is
> discouraged.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com

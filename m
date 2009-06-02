Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46643 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZFBL3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 07:29:40 -0400
Received: by pzk7 with SMTP id 7so6590703pzk.33
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2009 04:29:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906021244.44288.laurent.pinchart@skynet.be>
References: <200906021244.44288.laurent.pinchart@skynet.be>
Date: Tue, 2 Jun 2009 20:29:41 +0900
Message-ID: <5e9665e10906020429p3d27ff9ie89bbd2a4aa19577@mail.gmail.com>
Subject: Re: VIDIOC_[GS]_JPEGCOMP clarifications
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,


On Tue, Jun 2, 2009 at 7:44 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> Hi everybody,
>
> the VIDIOC_[GS]_JPEGCOMP documentation in the V4L2 specification is far from
> being clear and complete (which is probably why it's marked as [to do]). I'm
> implementing support for this ioctl in the uvcvideo driver and I'd like to
> request your opinion about the expected ioctl behavior.
>
> - VIDIOC_[GS]_JPEGCOMP only make sense for (M)JPEG compressed formats. Should
> the ioctls return an error (-EINVAL ?) when the currently selected format
> isn't (M)JPEG ?

I think JPEGCOMP ioctl is not respected doing the compression job
right at time it is being issued. In my opinion, it has to be saved
until next time it issues JPEG encoding with proper pixel format like
(M)JPEG. So, it seems to be OK not to return error even if it is not
working with expected JPEG format at the moment.


>
> - VIDIOC_S_JPEGCOMP is a write-only ioctl. As such it can't return the quality
> value really applied to the device when the requested quality can't be
> achieved (either because the value is out of bounds or the quality values
> supported by the device have a higher granularity). Should the ioctl still
> succeed in that case, and apply a closest match quality to the device ?
>

I think the quality parameter is not that critical item to be
configured that precisely in some point of view. But it is obvious
that it shouldn't be OK if it is not configured with "closest
matching" quality. I think this quantified way of quality setting is
quite choosy. I prefer to configure with preset like "high quality"
"standard quality" "low quality"...
So, I should say that it's not that critical to be configured to with
closest matching quality but not to far from expecting quality. (is it
maintainable in driver?)

> - Similarly, should VIDIOC_S_JPEGCOMP fail if the requested JPEG markers
> combination is not supported by the device, or should it silently fix the
> value ?

If the device is just supporting only encoder feature, it may be OK I
guess.. But if it supports encoder and decoder both of them and user
application trying to use decoder feature on encoded output with it's
own encoder, I'm afraid in some cases it can be matter. Especially
with quantization tables markers.

I think in this case it should return error if there is any problem
with JPEG markers in the first place


>
> - While JPEG-specific fields (such as markers) don't make sense for frame-
> based compressed formats other than (M)JPEG, the quality field does. Would it
> be abusing the ioctl to use the quality field to get/set the compression
> quality for compression formats similar to JPEG ? If it would, what's the
> preferred way to set compression quality in V4L2 ?
>

In the close context I posted a RFC for ENUM_FRAMESIZES for JPEG (not
the compression rate sorry). Can I have your opinion about that if you
don't mind? Please find following archive :
http://www.spinics.net/lists/linux-media/msg05013.html
Cheers,

Nate

> Best regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3191 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZKQOai (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:30:38 -0500
Message-ID: <bcadba622a1f6b6a0c429c733e0af447.squirrel@webmail.xs4all.nl>
In-Reply-To: <4B02AA78.6050102@infradead.org>
References: <4B02AA78.6050102@infradead.org>
Date: Tue, 17 Nov 2009 15:30:37 +0100
Subject: Re: [Fwd: [PATCH 2.6.31.5 1/1] v4l2: add new define for last
 camera class 	control id]
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Bertrand" <ba@cykian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Bertrand,
>
> Please, always send patches c/c to:
>         linux-media@vger.kernel.org.
> This way, people can better review it.
>
> For more details, please read:
>         http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
>
> There are some additional details on how patch submission works at:
>         http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches
>
> I'm forwarding it to the ML. I'll comment about it there.
>
> Cheers,
> Mauro.
>
> -------- Mensagem original --------
> Assunto: [PATCH 2.6.31.5 1/1] v4l2: add new define for last camera class
> 	control id
> Data: Wed, 11 Nov 2009 22:00:24 +0100
> De: Bertrand <ba@cykian.net>
> Para: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> The videodev2.h file contains, among other things, defines that point
> to the control properties of video devices.
>
> For the standard video controls, there is a V4L2_CID_BASE define for
> the base, and a pointer to the last control ID plus 1 named
> V4L2_CID_LASTP1.
> This allows automatic, version independent enumeration of the controls.
>
> There are other controls which are specific to the camera class
> devices. While there is a V4L2_CID_CAMERA_CLASS_BASE define, there was
> none for the last one.
> As a result it was not possible to do an enumeration of the controls
> of that class. This patch corrects this by adding a
> V4L2_CID_CAMERA_CLASS_LASTP1 define.

Hi Bertrand,

Enumerating controls that are not part of the user controls or the private
controls must use the V4L2_CTRL_FLAG_NEXT_CTRL flag when enumerating:

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#id2762121

If a driver does not support that, then that driver should be fixed.

Note that this can also be used for user and private controls, but most
drivers do not do that. I'm working on a better driver framework that will
handle this in the core inside of depending on the driver support.

The old style of using LASTP defines is really bad and inflexible and
should be avoided for extended controls.

Regards,

        Hans

>
> Signed-off-by: Bertrand Achard <ba@cykian.net>
>
> --- linux-2.6.31.5/include/linux/videodev2.h	2009-10-23 00:57:56.000000000
> +0200
> +++ linux-2.6.31.5-n/include/linux/videodev2.h	2009-11-11
> 21:48:48.000000000 +0100
> @@ -1147,6 +1147,8 @@ enum  v4l2_exposure_auto_type {
>
>  #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
>
> +#define V4L2_CID_CAMERA_CLASS_LASTP1		(V4L2_CID_CAMERA_CLASS_BASE+17)
> +
>  /*
>   *	T U N I N G
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


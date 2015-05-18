Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53931 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbbERTR5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 15:17:57 -0400
Date: Mon, 18 May 2015 16:17:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook/media: fix querycap error code
Message-ID: <20150518161751.57127058@recife.lan>
In-Reply-To: <5549B63F.7020009@xs4all.nl>
References: <5549B63F.7020009@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 May 2015 08:35:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The most likely error you will get when calling VIDIOC_QUERYCAP for a
> device node that does not support it is ENOTTY, not EINVAL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-querycap.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> index 20fda75..131abca 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> @@ -54,7 +54,7 @@ kernel devices compatible with this specification and to obtain
>  information about driver and hardware capabilities. The ioctl takes a
>  pointer to a &v4l2-capability; which is filled by the driver. When the
>  driver is not compatible with this specification the ioctl returns an
> -&EINVAL;.</para>
> +error, most likely the &ENOTTY;.</para>

Hmm... "likely"...

This is not nice... This is an specification. It should properly define
the error code, and not let the user to guess.

This should be, instead:
	"All V4L2 drivers should support VIDIOC_QUERYCAP."

The Documentation already points to to the generic error codes, 
with would actually happen only in the case something goes deadly wrong. 
There are very few error codes that could actually happen on this point,
like EFAULT, if, for some reason, the Kernel fails to copy data to 
userspace, or ENODEV is a device got removed.

Of course, if onse sends this ioctl to a non-v4l2 device, an error
code will be returned, but the actual error code will depend on the
device where this is sent, as, except if one janitor did a huge
changeset fixing this, I'm almost sure that not all devices will
return ENOTTY when an ioctl is not implemented.

Yet, for userspace, it is safe to assume that, if VIDIOC_QUERYCAP
fails, either the device is not V4L2 or the V4L2 device won't work
anyway, as there's something really broken there.

Regards,
Mauro


>  
>      <table pgwide="1" frame="none" id="v4l2-capability">
>        <title>struct <structname>v4l2_capability</structname></title>

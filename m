Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55458 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbcIHMYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:24:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>, Nick Dyer <nick@shmanahar.org>
Subject: Re: [PATCH 22/47] [media] v4l2-dev.rst: fix a broken c domain reference
Date: Thu, 08 Sep 2016 15:25:18 +0300
Message-ID: <4201881.nk0lNdyhtj@avalon>
In-Reply-To: <906d2519d19a3cf6914e440668494e8b479f216e.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com> <906d2519d19a3cf6914e440668494e8b479f216e.1473334905.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday 08 Sep 2016 09:03:44 Mauro Carvalho Chehab wrote:
> The "struct" were inside the reference, causing it to break.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/media/kapi/v4l2-dev.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/kapi/v4l2-dev.rst
> b/Documentation/media/kapi/v4l2-dev.rst index 5782be725334..0a3b4503a89f
> 100644
> --- a/Documentation/media/kapi/v4l2-dev.rst
> +++ b/Documentation/media/kapi/v4l2-dev.rst
> 
> @@ -56,7 +56,7 @@ You should also set these fields of 
:c:type:`video_device`:
>    :c:type:`video_device`->vfl_dir fields are used to disable ops that do
>    :not
> 
>    match the type/dir combination. E.g. VBI ops are disabled for non-VBI
> nodes, and output ops  are disabled for a capture device. This makes it
> possible to -  provide just one :c:type:`v4l2_ioctl_ops struct` for both
> vbi and +  provide just one :c:type:`v4l2_ioctl_ops` struct for both vbi
> and video nodes.
> 
>  - :c:type:`video_device`->lock: leave to ``NULL`` if you want to do all the

-- 
Regards,

Laurent Pinchart


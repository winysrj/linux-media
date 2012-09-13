Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2397 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab2IMVAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 17:00:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] DocBook: Fix docbook compilation
Date: Thu, 13 Sep 2012 23:00:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1347567100-2256-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1347567100-2256-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209132300.03671.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu September 13 2012 22:11:40 Mauro Carvalho Chehab wrote:
> changeset 1248c7cb66d734b60efed41be7c7b86909812c0e broke html compilation:
> 
> Documentation/DocBook/v4l2.xml:584: parser error : Entity 'sub-subdev-g-edid' not defined
> Documentation/DocBook/v4l2.xml:626: parser error : chunk is not well balanced
> Documentation/DocBook/media_api.xml:74: parser error : Failure to process entity sub-v4l2
> Documentation/DocBook/media_api.xml:74: parser error : Entity 'sub-v4l2' not defined
> 
> I suspect that one file was simply missed at the patch.

Indeed. The missing vidioc-subdev-g-edid.xml file is here:

https://patchwork.kernel.org/patch/1209461/

I forgot to do a git add when I made the RFCv3, but that documentation file
hasn't changed since RFCv2, so you can just use the one from RFCv2 and revert
this patch.

My apologies, I haven't found a good way yet to check that I didn't forgot to
add a file.

Regards,

	Hans

> Yet, keeping
> it broken is a very bad idea, so we should either remove the broken
> patch or to remove just the invalid include. Let's take the latter
> approach.
> 
> Due to that, a warning is now produced:
> 
> Error: no ID for constraint linkend: v4l2-subdev-edid.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/DocBook/media/v4l/v4l2.xml | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 10ccde9..0292ed1 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -581,7 +581,6 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-subdev-enum-frame-size;
>      &sub-subdev-enum-mbus-code;
>      &sub-subdev-g-crop;
> -    &sub-subdev-g-edid;
>      &sub-subdev-g-fmt;
>      &sub-subdev-g-frame-interval;
>      &sub-subdev-g-selection;
> 

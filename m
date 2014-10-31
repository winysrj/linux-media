Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52424 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248AbaJaOyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 10:54:09 -0400
Message-ID: <5453A289.5020007@xs4all.nl>
Date: Fri, 31 Oct 2014 15:54:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] DocBook media: Clarify V4L2_FIELD_ANY for drivers
References: <1414766908-24894-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1414766908-24894-1-git-send-email-simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/31/2014 03:48 PM, Simon Farnsworth wrote:
> Documentation for enum v4l2_field did not make it clear that V4L2_FIELD_ANY
> is only acceptable as input to the kernel, not as a response from the
> driver.
> 
> Make it clear, to stop userspace developers like me assuming it can be
> returned by the driver.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> ---
>  Documentation/DocBook/media/v4l/io.xml | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index e5e8325..8918bb2 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -1422,7 +1422,10 @@ one of the <constant>V4L2_FIELD_NONE</constant>,
>  <constant>V4L2_FIELD_BOTTOM</constant>, or
>  <constant>V4L2_FIELD_INTERLACED</constant> formats is acceptable.
>  Drivers choose depending on hardware capabilities or e.&nbsp;g. the
> -requested image size, and return the actual field order. &v4l2-buffer;
> +requested image size, and return the actual field order. If multiple
> +field orders are possible the driver must choose one of the possible
> +field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT; and must not
> +return V4L2_FIELD_ANY. &v4l2-buffer;

I would phrase it slightly differently:

"Drivers must never return <constant>V4L2_FIELD_ANY</constant>. If multiple
field orders are possible the driver must choose one of the possible
field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT;."

Regards,

	Hans

>  <structfield>field</structfield> can never be
>  <constant>V4L2_FIELD_ANY</constant>.</entry>
>  	  </row>
> 


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52516 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbbEQLOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 07:14:21 -0400
Message-ID: <55587808.4070605@xs4all.nl>
Date: Sun, 17 May 2015 13:14:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH] DocBook: fix vidioc-qbuf.xml doc validation
References: <1431828874-8108-1-git-send-email-crope@iki.fi>
In-Reply-To: <1431828874-8108-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Duplicate of http://www.spinics.net/lists/linux-media/msg89715.html

Just posted the pull request containing that patch.

I noticed the same problem on Friday :-)

Regards,

	Hans

On 05/17/2015 04:14 AM, Antti Palosaari wrote:
> element varlistentry: validity error : Element varlistentry content
> does not follow the DTD, expecting (term+ , listitem), got (term
> listitem term listitem )
> 
> commit 8cee396bfa77ce3a2e5fe48f597206c1cd547f9c
> [media] DocBook media: document codec draining flow
> breaks document validation. Fix it.
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 6cfc53b..f5cef97 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -186,6 +186,8 @@ In that case the application should be able to safely reuse the buffer and
>  continue streaming.
>  	</para>
>  	</listitem>
> +      </varlistentry>
> +      <varlistentry>
>  	<term><errorcode>EPIPE</errorcode></term>
>  	<listitem>
>  	  <para><constant>VIDIOC_DQBUF</constant> returns this on an empty
> 

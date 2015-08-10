Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56851 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbbHJJlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:41:40 -0400
Message-ID: <55C871B9.2080207@xs4all.nl>
Date: Mon, 10 Aug 2015 11:41:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 12/13] DocBook: fix S_FREQUENCY => G_FREQUENCY
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-13-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-13-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> It is VIDIOC_G_FREQUENCY which does not use type to identify tuner,
> not VIDIOC_S_FREQUENCY. VIDIOC_S_FREQUENCY uses both tuner and type
> fields. One of these V4L API weirdness...

Actually, that's not what this is about. It's about whether g/s_frequency gets/sets
the frequency for the tuner or the modulator. That has nothing to do with the tuner
and type fields. The problem described here in the spec is a problem for both G and
S_FREQUENCY.

Regards,

	Hans

> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/common.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> index 8b5e014..f7008ea 100644
> --- a/Documentation/DocBook/media/v4l/common.xml
> +++ b/Documentation/DocBook/media/v4l/common.xml
> @@ -428,7 +428,7 @@ zero, no video outputs.</para>
>  modulator. Two separate device nodes will have to be used for such
>  hardware, one that supports the tuner functionality and one that supports
>  the modulator functionality. The reason is a limitation with the
> -&VIDIOC-S-FREQUENCY; ioctl where you cannot specify whether the frequency
> +&VIDIOC-G-FREQUENCY; ioctl where you cannot specify whether the frequency
>  is for a tuner or a modulator.</para>
>  
>        <para>To query and change modulator properties applications use
> 


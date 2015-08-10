Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44061 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141AbbHJJDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:03:13 -0400
Message-ID: <55C868B7.8030302@xs4all.nl>
Date: Mon, 10 Aug 2015 11:02:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 07/13] DocBook: add modulator type field
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-8-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-8-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> Add new modulator type field to documentation.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> index 7068b59..fe4230c 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> @@ -140,7 +140,13 @@ indicator, for example a stereo pilot tone.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[4]</entry>
> +	    <entry><structfield>type</structfield></entry>
> +	    <entry spanname="hspan">Type of the tuner, see <xref

s/tuner/modulator/

Regards,

	Hans

> +		linkend="v4l2-tuner-type" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
>  	    <entry>Reserved for future extensions. Drivers and
>  applications must set the array to zero.</entry>
>  	  </row>
> 


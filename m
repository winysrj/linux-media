Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37006 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849AbbIDKll (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 06:41:41 -0400
Message-ID: <55E97527.6060601@xs4all.nl>
Date: Fri, 04 Sep 2015 12:40:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/13] DocBook: add modulator type field
References: <1441144769-29211-1-git-send-email-crope@iki.fi> <1441144769-29211-8-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-8-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2015 11:59 PM, Antti Palosaari wrote:
> Add new modulator type field to documentation.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> index 7068b59..80167fc 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> @@ -140,7 +140,13 @@ indicator, for example a stereo pilot tone.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[4]</entry>
> +	    <entry><structfield>type</structfield></entry>
> +	    <entry spanname="hspan">Type of the modulator, see <xref
> +		linkend="v4l2-tuner-type" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
>  	    <entry>Reserved for future extensions. Drivers and
>  applications must set the array to zero.</entry>
>  	  </row>
> 


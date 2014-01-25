Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3482 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaAYI1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:27:43 -0500
Message-ID: <52E37573.8020400@xs4all.nl>
Date: Sat, 25 Jan 2014 09:27:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 13/13] devices.txt: add video4linux device for
 Software Defined Radio
References: <1390511333-25837-1-git-send-email-crope@iki.fi> <1390511333-25837-14-git-send-email-crope@iki.fi>
In-Reply-To: <1390511333-25837-14-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

On 01/23/2014 10:08 PM, Antti Palosaari wrote:
> Add new video4linux device named /dev/swradio for Software Defined
> Radio use. V4L device minor numbers are allocated dynamically
> nowadays, but there is still configuration option for old fixed style.
> Add note to mention that configuration option too.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/devices.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 80b7241..e852855 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -1490,10 +1490,17 @@ Your cooperation is appreciated.
>  		 64 = /dev/radio0	Radio device
>  		    ...
>  		127 = /dev/radio63	Radio device
> +		128 = /dev/swradio0	Software Defined Radio device
> +		    ...
> +		191 = /dev/swradio63	Software Defined Radio device
>  		224 = /dev/vbi0		Vertical blank interrupt
>  		    ...
>  		255 = /dev/vbi31	Vertical blank interrupt
>  
> +		Minor numbers are allocated dynamically unless
> +		CONFIG_VIDEO_FIXED_MINOR_RANGES (default n)
> +		configuration option is set.
> +
>   81 block	I2O hard disk
>  		  0 = /dev/i2o/hdq	17th I2O hard disk, whole disk
>  		 16 = /dev/i2o/hdr	18th I2O hard disk, whole disk
> 

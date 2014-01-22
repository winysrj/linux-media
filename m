Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1126 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAVHUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 02:20:53 -0500
Message-ID: <52DF713D.4050904@xs4all.nl>
Date: Wed, 22 Jan 2014 08:20:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] devices.txt: add video4linux device for Software Defined
 Radio
References: <1390364390-9377-1-git-send-email-crope@iki.fi>
In-Reply-To: <1390364390-9377-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2014 05:19 AM, Antti Palosaari wrote:
> Add new	video4linux device named /dev/swradio for Software Defined
> Radio use. V4L device minor numbers are allocated dynamically
> nowadays.

Actually, that's not true. If the VIDEO_FIXED_MINOR_RANGES config option is
set, then the fixed ranges will be used. In that case the devices use minors
from 128-191. This range is shared with v4l-subdev devices.

> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/devices.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 80b7241..ac6ff84 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -1493,6 +1493,9 @@ Your cooperation is appreciated.
>  		224 = /dev/vbi0		Vertical blank interrupt
>  		    ...
>  		255 = /dev/vbi31	Vertical blank interrupt
> +		  0 = /dev/swradio0	Software Defined Radio device
> +		  1 = /dev/swradio1	Software Defined Radio device
> +		    ...
>  
>   81 block	I2O hard disk
>  		  0 = /dev/i2o/hdq	17th I2O hard disk, whole disk
> 

Regards,

	Hans

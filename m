Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44005 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725749AbeJIFa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 01:30:29 -0400
Subject: Re: [PATCH] vivid: fix kernel oops when enabling HFLIP and OSD
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <407e067b-47be-e8da-848d-edb6c04f5c1c@xs4all.nl>
Message-ID: <b0c7c982-2c93-0840-038f-78196de6c212@xs4all.nl>
Date: Tue, 9 Oct 2018 00:16:28 +0200
MIME-Version: 1.0
In-Reply-To: <407e067b-47be-e8da-848d-edb6c04f5c1c@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 09:08 PM, Hans Verkuil wrote:
> When the OSD is on (i.e. vivid displays text on top of the test pattern), and
> you enable hflip, then the driver crashes.
> 
> The cause turned out to be a division of a negative number by an unsigned value.
> You expect that -8 / 2 would be -4, but in reality it is 2147483644 :-(
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index f3d9c1140ffa..e76f87dc4368 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -1773,7 +1773,7 @@ typedef struct { u16 __; u8 _; } __packed x24;
>  				pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
>  			} \
>  	\
> -			pos += (tpg->hflip ? -8 : 8) / hdiv;	\
> +			pos += (tpg->hflip ? -8 : 8) / (int)hdiv;	\
>  		}	\
>  	}	\
>  } while (0)
> 

Fixes: 3e14e7a82c1ef ("vivid-tpg: add hor/vert downsampling support to tpg_gen_text")

Regards,

	Hans

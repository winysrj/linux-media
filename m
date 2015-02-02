Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58381 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbbBBNVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 08:21:55 -0500
Message-ID: <54CF79CB.6000603@xs4all.nl>
Date: Mon, 02 Feb 2015 14:21:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: vino: vino: Removed variables that is
 never used
References: <1422485265-11231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422485265-11231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2015 11:47 PM, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck

FYI: I've dropped this patch since the vino driver will be removed in 3.20.

Regards.

	Hans

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/media/vino/vino.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/media/vino/vino.c b/drivers/staging/media/vino/vino.c
> index 2c85357..f43c1ea 100644
> --- a/drivers/staging/media/vino/vino.c
> +++ b/drivers/staging/media/vino/vino.c
> @@ -2375,7 +2375,6 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
>  		next_4_desc = vino->a.next_4_desc;
>  	unsigned int line_count_2,
>  		page_index_2,
> -		field_counter_2,
>  		start_desc_tbl_2,
>  		next_4_desc_2;
>  #endif
> @@ -2421,7 +2420,6 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
>  #ifdef VINO_DEBUG_INT
>  			line_count_2 = vino->a.line_count;
>  			page_index_2 = vino->a.page_index;
> -			field_counter_2 = vino->a.field_counter;
>  			start_desc_tbl_2 = vino->a.start_desc_tbl;
>  			next_4_desc_2 = vino->a.next_4_desc;
>  
> 


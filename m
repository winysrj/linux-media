Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51080 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbbAPKmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 05:42:18 -0500
Message-ID: <54B8EAF8.50109@xs4all.nl>
Date: Fri, 16 Jan 2015 11:42:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: Re: [PATCH] media: pci: solo6x10: solo6x10-enc.c:  Remove unused
 function
References: <1419184727-11224-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419184727-11224-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ismael, Andrey,

Can you take a look at this? Shouldn't solo_s_jpeg_qp() be hooked up to something?

Regards,

	Hans

On 12/21/2014 06:58 PM, Rickard Strandqvist wrote:
> Remove the function solo_s_jpeg_qp() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/media/pci/solo6x10/solo6x10-enc.c |   35 -----------------------------
>  drivers/media/pci/solo6x10/solo6x10.h     |    2 --
>  2 files changed, 37 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-enc.c b/drivers/media/pci/solo6x10/solo6x10-enc.c
> index d19c0ae..6b589b8 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-enc.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-enc.c
> @@ -175,41 +175,6 @@ out:
>  	return 0;
>  }
>  
> -/**
> - * Set channel Quality Profile (0-3).
> - */
> -void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
> -		    unsigned int qp)
> -{
> -	unsigned long flags;
> -	unsigned int idx, reg;
> -
> -	if ((ch > 31) || (qp > 3))
> -		return;
> -
> -	if (solo_dev->type == SOLO_DEV_6010)
> -		return;
> -
> -	if (ch < 16) {
> -		idx = 0;
> -		reg = SOLO_VE_JPEG_QP_CH_L;
> -	} else {
> -		ch -= 16;
> -		idx = 1;
> -		reg = SOLO_VE_JPEG_QP_CH_H;
> -	}
> -	ch *= 2;
> -
> -	spin_lock_irqsave(&solo_dev->jpeg_qp_lock, flags);
> -
> -	solo_dev->jpeg_qp[idx] &= ~(3 << ch);
> -	solo_dev->jpeg_qp[idx] |= (qp & 3) << ch;
> -
> -	solo_reg_write(solo_dev, reg, solo_dev->jpeg_qp[idx]);
> -
> -	spin_unlock_irqrestore(&solo_dev->jpeg_qp_lock, flags);
> -}
> -
>  int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch)
>  {
>  	int idx;
> diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> index 72017b7..ad5afc6 100644
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -399,8 +399,6 @@ int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
>  		      __be16 data);
>  
>  /* JPEG Qp functions */
> -void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
> -		    unsigned int qp);
>  int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch);
>  
>  #define CHK_FLAGS(v, flags) (((v) & (flags)) == (flags))
> 


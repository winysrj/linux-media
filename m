Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B29C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72FC2147C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfCLINi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:13:38 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42499 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbfCLINh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:13:37 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3cXUhYdYj4HFn3cXXhILQy; Tue, 12 Mar 2019 09:13:36 +0100
Subject: Re: [PATCH] media: Drop superfluous PCM preallocation error checks
To:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
References: <20190206173239.18046-1-tiwai@suse.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7393e26f-621f-1855-2829-846e909e3475@xs4all.nl>
Date:   Tue, 12 Mar 2019 09:13:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190206173239.18046-1-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNgH1shEZMv+DzeCysPRbpsZvkbCxs+GY/1rA4VoBpO4I0g+iPC9ovfqkTEhSBQCmFjMybt3XuAlT1iLk+79V4A2PqMo0XG4S0hg863tEvSJF2jqqXLW
 eOnQBlTee4L5kKCn57APZQywhrVOfG3eziyaCf9Pk0PSk6TzBytUDaOOX8mifjpWekSgMCN9qqT7JZf1aaEYhLLRpLmVkDGLsvK4L/vMhaBqWhdQpkezJDxV
 hcahKOxtOv6BZ3VkKb5lhauegQKKy9JnRNZDEBBh6hfy8EUlVrH8ULJ9M0fXYqj5ekd9MeF78iHg4Yi5E7fTOw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Takashi,

On 2/6/19 6:32 PM, Takashi Iwai wrote:
> snd_pcm_lib_preallocate_pages() and co always succeed, so the error
> check is simply redundant.  Drop it.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

I can take it as for 5.2, but you can as well with my Ack. If you want me
to take it, let me know.

Regards,

	Hans

> ---
> 
> This is a piece I overlooked in the previous patchset:
>    https://www.spinics.net/lists/alsa-devel/msg87223.html
> 
> Media people, please give ACK if this is OK.  Then I'll merge it together
> with other relevant patches.  Thanks!
> 
>  drivers/media/pci/solo6x10/solo6x10-g723.c | 4 +---
>  drivers/media/pci/tw686x/tw686x-audio.c    | 3 ++-
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
> index 2cc05a9d57ac..a16242a9206f 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -360,13 +360,11 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
>  	     ss; ss = ss->next, i++)
>  		sprintf(ss->name, "Camera #%d Audio", i);
>  
> -	ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
> +	snd_pcm_lib_preallocate_pages_for_all(pcm,
>  					SNDRV_DMA_TYPE_CONTINUOUS,
>  					snd_dma_continuous_data(GFP_KERNEL),
>  					G723_PERIOD_BYTES * PERIODS,
>  					G723_PERIOD_BYTES * PERIODS);
> -	if (ret < 0)
> -		return ret;
>  
>  	solo_dev->snd_pcm = pcm;
>  
> diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
> index a28329698e20..fb0e7573b5ae 100644
> --- a/drivers/media/pci/tw686x/tw686x-audio.c
> +++ b/drivers/media/pci/tw686x/tw686x-audio.c
> @@ -301,11 +301,12 @@ static int tw686x_snd_pcm_init(struct tw686x_dev *dev)
>  	     ss; ss = ss->next, i++)
>  		snprintf(ss->name, sizeof(ss->name), "vch%u audio", i);
>  
> -	return snd_pcm_lib_preallocate_pages_for_all(pcm,
> +	snd_pcm_lib_preallocate_pages_for_all(pcm,
>  				SNDRV_DMA_TYPE_DEV,
>  				snd_dma_pci_data(dev->pci_dev),
>  				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX,
>  				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX);
> +	return 0;
>  }
>  
>  static void tw686x_audio_dma_free(struct tw686x_dev *dev,
> 


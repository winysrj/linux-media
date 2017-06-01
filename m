Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37240 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751050AbdFAVa6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 17:30:58 -0400
Subject: Re: [PATCH v2 15/27] [media] solo6x10: Convert to the new PCM ops
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Mark Brown <broonie@kernel.org>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
References: <20170601205850.24993-1-tiwai@suse.de>
 <20170601205850.24993-16-tiwai@suse.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <66f934b5-2181-13e1-17ef-8c9acc2a5cfa@xs4all.nl>
Date: Thu, 1 Jun 2017 23:30:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170601205850.24993-16-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2017 10:58 PM, Takashi Iwai wrote:
> Replace the copy and the silence ops with the new PCM ops.
> The device supports only 1 channel and 8bit sample, so it's always
> bytes=frames, and we need no conversion of unit in the callback.
> Also, it's a capture stream, thus no silence is needed.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>   drivers/media/pci/solo6x10/solo6x10-g723.c | 32 ++++++++++++++++++++++--------
>   1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
> index 36e93540bb49..3ca947092775 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -223,9 +223,9 @@ static snd_pcm_uframes_t snd_solo_pcm_pointer(struct snd_pcm_substream *ss)
>   	return idx * G723_FRAMES_PER_PAGE;
>   }
>   
> -static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
> -			     snd_pcm_uframes_t pos, void __user *dst,
> -			     snd_pcm_uframes_t count)
> +static int __snd_solo_pcm_copy(struct snd_pcm_substream *ss,
> +			       unsigned long pos, void *dst,
> +			       unsigned long count, bool in_kernel)
>   {
>   	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
>   	struct solo_dev *solo_dev = solo_pcm->solo_dev;
> @@ -242,16 +242,31 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
>   		if (err)
>   			return err;
>   
> -		err = copy_to_user(dst + (i * G723_PERIOD_BYTES),
> -				   solo_pcm->g723_buf, G723_PERIOD_BYTES);
> -
> -		if (err)
> +		if (in_kernel)
> +			memcpy(dst, solo_pcm->g723_buf, G723_PERIOD_BYTES);
> +		else if (copy_to_user((void __user *)dst,
> +				      solo_pcm->g723_buf, G723_PERIOD_BYTES))
>   			return -EFAULT;
> +		dst += G723_PERIOD_BYTES;
>   	}
>   
>   	return 0;
>   }
>   
> +static int snd_solo_pcm_copy_user(struct snd_pcm_substream *ss, int channel,
> +				  unsigned long pos, void __user *dst,
> +				  unsigned long count)
> +{
> +	return __snd_solo_pcm_copy(ss, pos, (void *)dst, count, false);
> +}
> +
> +static int snd_solo_pcm_copy_kernel(struct snd_pcm_substream *ss, int channel,
> +				    unsigned long pos, void *dst,
> +				    unsigned long count)
> +{
> +	return __snd_solo_pcm_copy(ss, pos, dst, count, true);
> +}
> +
>   static const struct snd_pcm_ops snd_solo_pcm_ops = {
>   	.open = snd_solo_pcm_open,
>   	.close = snd_solo_pcm_close,
> @@ -261,7 +276,8 @@ static const struct snd_pcm_ops snd_solo_pcm_ops = {
>   	.prepare = snd_solo_pcm_prepare,
>   	.trigger = snd_solo_pcm_trigger,
>   	.pointer = snd_solo_pcm_pointer,
> -	.copy = snd_solo_pcm_copy,
> +	.copy_user = snd_solo_pcm_copy_user,
> +	.copy_kernel = snd_solo_pcm_copy_kernel,
>   };
>   
>   static int snd_solo_capture_volume_info(struct snd_kcontrol *kcontrol,
> 

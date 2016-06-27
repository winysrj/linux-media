Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:32838 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbcF0PiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 11:38:13 -0400
Received: by mail-wm0-f50.google.com with SMTP id r190so21903015wmr.0
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 08:37:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d4ce2282-1ad9-369c-fc37-92fe402a0e13@xs4all.nl>
References: <d4ce2282-1ad9-369c-fc37-92fe402a0e13@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 27 Jun 2016 12:37:40 -0300
Message-ID: <CAAEAJfBD-pnM1HkdNgPzVVaLV07jTGKKk-OX+-SNczxUZwJ3-g@mail.gmail.com>
Subject: Re: [PATCH] tw686x: be explicit about the possible dma_mode options
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 June 2016 at 05:31, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Users won't know what to put in this module option if it isn't
> described.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Ezequiel, this sits on top of your tw686x patch series and will be part of the pull
> request.

It looks good.

Thanks!

> ---
>  drivers/media/pci/tw686x/tw686x-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
> index 586bc67..71a0453 100644
> --- a/drivers/media/pci/tw686x/tw686x-core.c
> +++ b/drivers/media/pci/tw686x/tw686x-core.c
> @@ -91,7 +91,7 @@ static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
>  }
>  module_param_call(dma_mode, tw686x_dma_mode_set, tw686x_dma_mode_get,
>                   &dma_mode, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(dma_mode, "DMA operation mode");
> +MODULE_PARM_DESC(dma_mode, "DMA operation mode (memcpy/contig/sg, default=memcpy)");
>
>  void tw686x_disable_channel(struct tw686x_dev *dev, unsigned int channel)
>  {
> --
> 2.8.1
>



-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar

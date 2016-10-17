Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54511 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932163AbcJQSxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 14:53:04 -0400
Date: Mon, 17 Oct 2016 20:52:57 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: mchehab@s-opensource.com, hverkuil@xs4all.nl
Cc: ismael@iodev.co.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, maintainers@bluecherrydvr.com,
        andrey.utkin@corp.bluecherry.net
Subject: Re: [PATCH] [media] solo6x10: avoid delayed register write
Message-ID: <20161017195257.GD21569@stationary.pb.com>
References: <20160922000331.4193-1-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160922000331.4193-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 22, 2016 at 03:03:31AM +0300, Andrey Utkin wrote:
> This fixes a lockup at device probing which happens on some solo6010
> hardware samples. This is a regression introduced by commit e1ceb25a1569
> ("[media] SOLO6x10: remove unneeded register locking and barriers")
> 
> The observed lockup happens in solo_set_motion_threshold() called from
> solo_motion_config().
> 
> This extra "flushing" is not fundamentally needed for every write, but
> apparently the code in driver assumes such behaviour at last in some
> places.
> 
> Actual fix was proposed by Hans Verkuil.
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  drivers/media/pci/solo6x10/solo6x10.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> index 5bd4987..3f8da5e 100644
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -284,7 +284,10 @@ static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
>  static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
>  				  u32 data)
>  {
> +	u16 val;
> +
>  	writel(data, solo_dev->reg_base + reg);
> +	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
>  }
>  
>  static inline void solo_irq_on(struct solo_dev *dev, u32 mask)
> -- 
> 2.9.2
> 

Mauro, Hans,
Please pick this up. This has been around for a month, I expected it
would get to v4.9-rc1 easily.
Thanks.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38722 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbcLST4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 14:56:45 -0500
Received: by mail-wm0-f54.google.com with SMTP id f82so111232359wmf.1
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2016 11:56:45 -0800 (PST)
Date: Mon, 19 Dec 2016 19:56:37 +0000
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, andrey_utkin@fastmail.com
Subject: Re: [PATCH] solo6x10: use designated initializers
Message-ID: <20161219195637.GA15652@dell-m4800>
References: <20161217010536.GA140725@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161217010536.GA140725@beast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 16, 2016 at 05:05:36PM -0800, Kees Cook wrote:
> Prepare to mark sensitive kernel structures for randomization by making
> sure they're using designated initializers. These were identified during
> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
> extracted from grsecurity.

Ok I've reviewed all the patchset, googled a bit and now I see what's
going on.

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
> index 6a35107aca25..36e93540bb49 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
>  
>  int solo_g723_init(struct solo_dev *solo_dev)
>  {
> -	static struct snd_device_ops ops = { NULL };
> +	static struct snd_device_ops ops = { };

I'm not that keen on syntax subtleties, but...
 * Empty initializer is not quite "designated" as I can judge.
 * From brief googling I see that empty initializer is not valid in
   some C standards.

Since `ops` is static, what about this?
For the variant given below, you have my signoff.

> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
>  
>  int solo_g723_init(struct solo_dev *solo_dev)
>  {
> -	static struct snd_device_ops ops = { NULL };
> +	static struct snd_device_ops ops;

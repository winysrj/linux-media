Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53803 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaBJN3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:06 -0500
Received: by mail-qa0-f49.google.com with SMTP id w8so9283914qac.8
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 05:29:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPLVkLtoos1FSiV-G8e=giN673Zmkyp7RAG-iKrkvLMz9BqRgw@mail.gmail.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
	<1344307634-11673-8-git-send-email-dheitmueller@kernellabs.com>
	<CAPLVkLv6JNvSdSFCY7YNRkmfzHv5+JD7Y5hxvjxdFtRT2JgE2A@mail.gmail.com>
	<CAGoCfixUNkFOji-LO2moDkj+8oBgLVkWNbC-otBWNu9JQWw88A@mail.gmail.com>
	<CAPLVkLtoos1FSiV-G8e=giN673Zmkyp7RAG-iKrkvLMz9BqRgw@mail.gmail.com>
Date: Mon, 10 Feb 2014 08:29:05 -0500
Message-ID: <CAGoCfiwUaD9dueXb8TunzXLyTKu6qvH05tpqimO4QiYju1ymsQ@mail.gmail.com>
Subject: Re: [PATCH 07/24] xc5000: properly report i2c write failures
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Joonyoung Shim <dofmind@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 10, 2014 at 3:25 AM, Joonyoung Shim <dofmind@gmail.com> wrote:
> As you said, i modified like below patch and it is working well.
>
> Thanks for your advice.
>
> diff --git a/drivers/media/usb/au0828/au0828-cards.c
> b/drivers/media/usb/au0828/au0828-cards.c
> index 0cb7c28..9936875 100644
> --- a/drivers/media/usb/au0828/au0828-cards.c
> +++ b/drivers/media/usb/au0828/au0828-cards.c
> @@ -108,7 +108,7 @@ struct au0828_board au0828_boards[] = {
>          .name    = "DViCO FusionHDTV USB",
>          .tuner_type = UNSET,
>          .tuner_addr = ADDR_UNSET,
> -        .i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
> +        .i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
>      },
>      [AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
>          .name = "Hauppauge Woodbury",

Great.  Feel free to submit a patch to the mailing list with your SOB,
and we'll merge that change upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

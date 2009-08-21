Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45453 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZHUDDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 23:03:46 -0400
Received: by fxm17 with SMTP id 17so260905fxm.37
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 20:03:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250822966.5248.6.camel@shinel>
References: <1250822966.5248.6.camel@shinel>
Date: Thu, 20 Aug 2009 23:03:46 -0400
Message-ID: <829197380908202003o2c72c0a4m50fd5e5bbdb1b1d9@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Don't call em28xx_ir_init when disable_ir is true
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: shinel@foxmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 20, 2009 at 10:49 PM, Shine Liu<shinel@foxmail.com> wrote:
> I think we should call em28xx_ir_init(dev) when disable_ir is true.
> Following patch will fix the bug.
>
> Cheers,
>
> Shine

Yeah, this looks reasonable.  I must have just accidentally cut the
code when I refactored the onboard IR support (as opposed to external
i2c IR).

In reality I really should take another pass over how the IR registers
are configured since currently we rely on the XCLK field definition in
the board configuration to setup the IR, which prevents you from
switching remote control modes between NEC/RC5/RC6, etc.

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

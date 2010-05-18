Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52978 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab0ERNYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 09:24:50 -0400
Received: by wyb39 with SMTP id 39so1311299wyb.19
        for <linux-media@vger.kernel.org>; Tue, 18 May 2010 06:24:49 -0700 (PDT)
Date: Tue, 18 May 2010 16:24:45 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si4713: Fix oops when si4713_platform_data is marked as
 __initdata
Message-Id: <20100518162445.5399d077.jhnikula@gmail.com>
In-Reply-To: <20100518125527.GB4265@besouro.research.nokia.com>
References: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>
	<20100518125527.GB4265@besouro.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 May 2010 15:55:27 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> wrote:

> I'm probably fine with this patch, and the driver must check for the pointer
> before using it, indeed.
> 
> But, I'm a bit skeptic about marking its platform data as __initdata. Would it make sense?
> What happens if driver is built as module and loaded / unload / loaded again?
> 
> Maybe the initdata flag does not apply in this case. Not sure (and not tested the above case).
> 
Yep, it doesn't work or make sense for modules if platform data is
marked as __initdata but with built in case it can save some bytes which
are not needed after kernel is initialized.

Like with this driver the i2c_bus number and i2_board_info data are not
needed after probing but only pointer to set_power must be preserved.


-- 
Jarkko

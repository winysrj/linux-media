Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33955 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbFAKNP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 06:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <1433153392-18037-1-git-send-email-geert@linux-m68k.org>
References: <1433153392-18037-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 1 Jun 2015 12:13:14 +0200
Message-ID: <CAMuHMdW6MAj6bOMY_RRt9=OF2iM2Gy4bCXWCEWK7hM5ia1Rtvg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v4.1-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 1, 2015 at 12:09 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v4.1-rc6[1] to v4.1-rc5[3], the summaries are:
>   - build errors: +8/-52

  + /home/kisskb/slave/src/drivers/media/i2c/ov2659.c: error: 'struct
v4l2_subdev_fh' has no member named 'pad':  => 1264:38
  + /home/kisskb/slave/src/drivers/media/i2c/ov2659.c: error: implicit
declaration of function 'v4l2_subdev_get_try_format'
[-Werror=implicit-function-declaration]:  => 1054:3

i386-randconfig

  + error: aes.c: undefined reference to `.enable_kernel_altivec':  =>
.text+0x48e894), .text+0x48e6e0), .text+0x48e960)
  + error: aes_cbc.c: undefined reference to `.enable_kernel_altivec':
 => .text+0x48ea98), .text+0x48ebf4)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8943/ (254 out of 257 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8914/ (254 out of 257 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

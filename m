Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36519 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGOK4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 06:56:10 -0400
Date: Sat, 15 Jul 2017 06:56:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org,
        Adam Manzanares <adam.manzanares@wdc.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH, RESEND 02/14] ata: avoid gcc-7 warning in
 ata_timing_quantize
Message-ID: <20170715105601.GC2969123@devbig577.frc2.facebook.com>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714092540.1217397-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714092540.1217397-3-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 11:25:14AM +0200, Arnd Bergmann wrote:
> gcc-7 warns about the result of a constant multiplication used as
> a boolean:
> 
> drivers/ata/libata-core.c: In function 'ata_timing_quantize':
> drivers/ata/libata-core.c:3164:30: warning: '*' in boolean context, suggest '&&' instead [-Wint-in-bool-context]
> 
> This slightly rearranges the macro to simplify the code and avoid
> the warning at the same time.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

If the whole series will be routed together,

 Acked-by: Tejun Heo <tj@kernel.org>

If not, please let me know.  I'll push it through
libata/for-4.13-fixes.

Thanks!

-- 
tejun

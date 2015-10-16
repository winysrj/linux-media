Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35811 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbbJPVmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 17:42:51 -0400
Received: by ykaz22 with SMTP id z22so94719359yka.2
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2015 14:42:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7188906.Hi9qi0FZQC@wuerfel>
References: <7188906.Hi9qi0FZQC@wuerfel>
Date: Fri, 16 Oct 2015 23:42:50 +0200
Message-ID: <CABxcv=kFNhdrGivGtk4O0gXKB7P_Uw9NYofpzNkaepVBFGjG6w@mail.gmail.com>
Subject: Re: [PATCH] [media] horus3a: fix horus3a_attach inline wrapper
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kozlov Sergey <serjk@netup.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Arnd,

On Fri, Oct 16, 2015 at 10:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The 'static inline' version of horus3a_attach() is incorrectly
> copied from another file, which results in a build error when
> CONFIG_DVB_HORUS3A is disabled:
>
> In file included from /git/arm-soc/drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
> media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
> media/dvb-frontends/horus3a.h:51:13: warning: its scope is only this definition or declaration, which is probably not what you want
> media/pci/netup_unidvb/netup_unidvb_core.c: In function 'netup_unidvb_dvb_init':
> media/pci/netup_unidvb/netup_unidvb_core.c:417:279: warning: passing argument 1 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
> media/pci/netup_unidvb/netup_unidvb_core.c:417:279: note: expected 'const struct cxd2820r_config *' but argument is of type 'struct dvb_frontend *'
> media/pci/netup_unidvb/netup_unidvb_core.c:417:298: warning: passing argument 2 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
> media/pci/netup_unidvb/netup_unidvb_core.c:417:298: note: expected 'struct i2c_adapter *' but argument is of type 'struct horus3a_config *'
> media/pci/netup_unidvb/netup_unidvb_core.c:417:275: error: too many arguments to function '__a'
>
> This changes the code to have the correct prototype.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: a5d32b358254 ("[media] horus3a: Sony Horus3A DVB-S/S2 tuner driver")
> ---

I posted the same patch a couple of weeks ago and was already picked
by Mauro on his fixes branch [0].

AFAIU that branch contains 4.3-rc material so I guess it will land
into mainline soon.

[0]: http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=de5abc98bf34e06d7accd943c4057843db921f00

Best regards,
Javier

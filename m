Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39098 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2EKMFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 08:05:00 -0400
Received: by vbbff1 with SMTP id ff1so2613659vbb.19
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 05:04:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336716892-5446-2-git-send-email-ismael.luceno@gmail.com>
References: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com>
	<1336716892-5446-2-git-send-email-ismael.luceno@gmail.com>
Date: Fri, 11 May 2012 08:04:59 -0400
Message-ID: <CAGoCfiydH48uY86w3oHbRDoJddX5qS1Va7vo4-vXwAn9JeSaaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] au0828: Move under dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2012 at 2:14 AM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
> ---
>  drivers/media/dvb/Kconfig                          |    1 +
>  drivers/media/dvb/Makefile                         |    1 +
>  drivers/media/{video => dvb}/au0828/Kconfig        |    0
>  drivers/media/{video => dvb}/au0828/Makefile       |    0
>  drivers/media/{video => dvb}/au0828/au0828-cards.c |    0
>  drivers/media/{video => dvb}/au0828/au0828-cards.h |    0
>  drivers/media/{video => dvb}/au0828/au0828-core.c  |    0
>  drivers/media/{video => dvb}/au0828/au0828-dvb.c   |    0
>  drivers/media/{video => dvb}/au0828/au0828-i2c.c   |    0
>  drivers/media/{video => dvb}/au0828/au0828-reg.h   |    0
>  drivers/media/{video => dvb}/au0828/au0828-vbi.c   |    0
>  drivers/media/{video => dvb}/au0828/au0828-video.c |    0
>  drivers/media/{video => dvb}/au0828/au0828.h       |    0
>  drivers/media/video/Kconfig                        |    2 --
>  drivers/media/video/Makefile                       |    2 --
>  15 files changed, 2 insertions(+), 4 deletions(-)
>  rename drivers/media/{video => dvb}/au0828/Kconfig (100%)
>  rename drivers/media/{video => dvb}/au0828/Makefile (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-cards.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-cards.h (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-core.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-dvb.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-i2c.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-reg.h (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-vbi.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828-video.c (100%)
>  rename drivers/media/{video => dvb}/au0828/au0828.h (100%)

What is the motivation for moving these files?  The au0828 is a hybrid
bridge, and every other hybrid bridge is under video?

NACK unless somebody can provide a good reason for doing this.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

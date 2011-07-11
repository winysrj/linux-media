Return-path: <mchehab@localhost>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60219 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1GKL5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 07:57:49 -0400
Received: by eyx24 with SMTP id 24so1316165eyx.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 04:57:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
References: <201107031831.20378@orion.escape-edv.de>
Date: Mon, 11 Jul 2011 07:57:47 -0400
Message-ID: <CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Sun, Jul 3, 2011 at 12:31 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> [PATCH 01/16] tda18271c2dd: Initial check-in
> [PATCH 02/16] tda18271c2dd: Lots of coding-style fixes

Oliver,

Why the new driver for the 18271c2?  There is already such a driver,
and in the past we've rejected multiple drivers for the same chip
unless there is a *very* compelling reason to do such.

The existing 18271 driver supports the C2 and is actively maintained.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

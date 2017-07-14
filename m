Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36830 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdGNTYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 15:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <20170714092540.1217397-9-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-9-arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jul 2017 12:24:45 -0700
Message-ID: <CA+55aFw076kkn_NS1K+nSHDLoajhviHUsnCOmJOpz5YajpEtFw@mail.gmail.com>
Subject: Re: [PATCH 08/14] Input: adxl34x - fix gcc-7 -Wint-in-bool-context warning
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 2:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> FIFO_MODE is an macro expression with a '<<' operator, which
> gcc points out could be misread as a '<':

Yeah, no, NAK again.

We don't make the code look worse just because gcc is being a f*cking
moron about things.

This warning is clearly pure garbage.

                 Linus

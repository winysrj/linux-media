Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34056 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdGNTVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 15:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20170714092540.1217397-4-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714092540.1217397-4-arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jul 2017 12:21:13 -0700
Message-ID: <CA+55aFw9xE_+qnx1=6FbU8HJ23+Go1iS5bxDLOHefETgn5Wx6w@mail.gmail.com>
Subject: Re: [PATCH, RESEND 03/14] drm/vmwgfx: avoid gcc-7 parentheses warning
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Brian Paul <brianp@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 2:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> -       return capable(CAP_SYS_ADMIN) ? : -EINVAL;
> +       return capable(CAP_SYS_ADMIN) ? 1 : -EINVAL;

NAK. This takes unintentionally insane code and turns it intentionally
insane. Any non-zero return is considered an error.

The right fix is almost certainly to just return -EINVAL unconditionally.

                  Linus

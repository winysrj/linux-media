Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35897 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0HCOv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 10:51:58 -0400
Received: by fxm14 with SMTP id 14so2017507fxm.19
        for <linux-media@vger.kernel.org>; Tue, 03 Aug 2010 07:51:57 -0700 (PDT)
Date: Tue, 3 Aug 2010 16:46:16 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, udia@siano-ms.com,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge
	WinTV MiniStick
Message-ID: <20100803144616.GA14809@linux-m68k.org>
References: <cover.1280693675.git.mchehab@redhat.com> <20100801171718.5ad62978@pedra> <20100802072711.GA5852@linux-m68k.org> <4C577888.30408@redhat.com> <20100803130552.GA9954@linux-m68k.org> <4C581A5F.5020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C581A5F.5020403@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 03, 2010 at 10:32:15AM -0300, Mauro Carvalho Chehab wrote:

> The model number is on a label at the back of the stick (at least, mine have it).

ah.. I was wondering whichever magical tool you are using. So here is my number:
55009 LF Rev A1F7


> Btw, you don't need to use lirc if all you want is to replace the IR keycodes. You can use, instead,
> the ir-keycode program, available at http://git.linuxtv.org/v4l-utils.git. There are several keycode
> tables already mapped there. Of course, lirc offers some extra features.

thanks for the tipps.. the userspace configuration seems more confusing than the kernel
internals. So far I get keycodes that work nicely in an xterm and for controling firefox
but not much else.


Richard

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911Ab0HCPXL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Aug 2010 11:23:11 -0400
Message-ID: <4C583473.3080700@redhat.com>
Date: Tue, 03 Aug 2010 12:23:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: linux-media@vger.kernel.org, udia@siano-ms.com,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge	WinTV
 MiniStick
References: <cover.1280693675.git.mchehab@redhat.com> <20100801171718.5ad62978@pedra> <20100802072711.GA5852@linux-m68k.org> <4C577888.30408@redhat.com> <20100803130552.GA9954@linux-m68k.org> <4C581A5F.5020403@redhat.com> <20100803144616.GA14809@linux-m68k.org>
In-Reply-To: <20100803144616.GA14809@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2010 11:46, Richard Zidlicky escreveu:
> On Tue, Aug 03, 2010 at 10:32:15AM -0300, Mauro Carvalho Chehab wrote:
> 
>> The model number is on a label at the back of the stick (at least, mine have it).
> 
> ah.. I was wondering whichever magical tool you are using. So here is my number:
> 55009 LF Rev A1F7

Ok, so it is close to mine. 

>> Btw, you don't need to use lirc if all you want is to replace the IR keycodes. You can use, instead,
>> the ir-keycode program, available at http://git.linuxtv.org/v4l-utils.git. There are several keycode
>> tables already mapped there. Of course, lirc offers some extra features.
> 
> thanks for the tipps.. the userspace configuration seems more confusing than the kernel
> internals. So far I get keycodes that work nicely in an xterm and for controling firefox
> but not much else.

Yes, that's the expected results without lirc. It will just use the RC as if it were a keyboard.
You can play with the IR, via ir-keycode, to use a different remote controller, or to reassign a
different keycode to a key. For example, reassigning the scancode for channel up as KEY_UP.


With lirc, you can also associate a keycode to an specific application, using for example, one key
to open your favorite TV application. There are some discussions about having a similar support
directly into X window managers, and direct support for RC into media applications, but, there's
no current patches for that, afaik.

Cheers,
Mauro.

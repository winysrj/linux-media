Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LByLT-0003eT-Qs
	for linux-dvb@linuxtv.org; Sun, 14 Dec 2008 22:17:49 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1044782fga.25
	for <linux-dvb@linuxtv.org>; Sun, 14 Dec 2008 13:17:44 -0800 (PST)
Message-ID: <412bdbff0812141317o170bd56fkeffad354dbb5fd3d@mail.gmail.com>
Date: Sun, 14 Dec 2008 16:17:37 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Ilia Penev" <picholicho@gmail.com>
In-Reply-To: <7b1b1f8d0812140909s63e74ab8g838f755f891c073f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7b1b1f8d0812140909s63e74ab8g838f755f891c073f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Gigabyte U8000 remote control who to use it?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/12/14 Ilia Penev <picholicho@gmail.com>:
> Hello there.
> i decide to find out how to run remote control.
> dmesg says some codes.
> dib0700: Unknown remote controller key : 18 43
>
> i write them in dib0700_device.c
> /*Gigabyte keys*/
>     { 0x18,0x43, KEY_POWER },
>     { 0x1e, 0x7d, KEY_0 },
>     { 0x14, 0x7f, KEY_1 },
>     { 0x19, 0x7c, KEY_2 },
>     { 0x1d, 0x7d, KEY_3 },
>     { 0x1c, 0x72, KEY_4 },
>     { 0x13, 0x4e, KEY_5 },
>     { 0x1b, 0x4c, KEY_6 },
>     { 0x14, 0x70, KEY_7 },
>     { 0x1e, 0x72, KEY_8 },
>     { 0x11, 0x4e, KEY_9 },
>     { 0x14, 0x40, KEY_VOLUMEUP },
>     { 0x1c, 0x42, KEY_VOLUMEDOWN },
>     { 0x10, 0x41, KEY_CHANNELUP },
>     { 0x1b, 0x7c, KEY_CHANNELDOWN },
>     { 0x13, 0x7e, KEY_MUTE },
> //    { 0x12, 0x7e, KEY_FM },
> //    { 0x1d, 0x42, KEY_VIDEOS },
>     { 0x15, 0x40, KEY_TV },
> //    { 0x1a, 0x7c, KEY_SNAPSHOT },
>     { 0x11, 0x41, KEY_LAST },
>     { 0x18, 0x7c, KEY_EPG },
>     { 0x1a, 0x43, KEY_BACK },
>     { 0x19, 0x4c, KEY_OK },
>     { 0x16, 0x70, KEY_UP },
>     { 0x12, 0x41, KEY_DOWN },
>     { 0x16, 0x7F, KEY_LEFT },
>     { 0x19, 0x43, KEY_RIGHT },
>
> how to define commented keys? in ir-keymaps.c? or somewhere else.
> i have problem when i put 1.20 firmware nothing happens with the remote
> control. with 1.10 when i press 5 apears 5 in console or where it is the
> cursor.
> remote appears as /dev/input/eventXX
> tell me some suggestions.
> many thanks :)
>
> Ilia

Hell Ilia,

Given the way dib0700 does remote controls, the change you proposed is
the correct way to add new remotes.  If you send a patch to the
mailing list, Patrick Boettcher is the person likely to merge it since
he is the dib0700 maintainer.

I really should work on getting the dib0700 driver integrated with
ir_keymaps.c so that the it is consistent with other drivers.

Regarding the 1.20 firmware, are you running the latest v4l-dvb code
from http://linuxtv.org/hg/v4l-dvb?  There were bugs in firmware
version 1.20 IR support that have been fixed in the last couple of
weeks.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

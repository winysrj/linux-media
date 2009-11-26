Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbZKZQZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 11:25:39 -0500
Message-ID: <4B0EABF8.9000902@redhat.com>
Date: Thu, 26 Nov 2009 14:25:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcbizrJjFB@christoph>
In-Reply-To: <BDcbizrJjFB@christoph>
Content-Type: multipart/mixed;
 boundary="------------090801070503010302000504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090801070503010302000504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Christoph Bartelmus wrote:
> Hi,
> 
> on 25 Nov 09 at 12:44, Jarod Wilson wrote:
> [...]
>> Ah, but the approach I'd take to converting to in-kernel decoding[*] would
>> be this:
> [...]
>> [*] assuming, of course, that it was actually agreed upon that in-kernel
>> decoding was the right way, the only way, all others will be shot on sight.
> 
> I'm happy to see that the discussion is getting along.
> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just  
> because I'm not familiar at all with input layer toolset.
> 
> 1. For sure in-kernel decoding will require some assistance from userspace  
> to load the mapping from IR codes to keys.

Current drivers have the IR keycode tables in-kernel also, directly associated
with the board ID.

> So, if there needs to be a tool  
> in userspace that does some kind of autodetection, why not have a tool  
> that does some autodetection and autoconfigures lircd for the current  
> device.

There are userspace tools to change the IR keycode maps. It shouldn't be hard to
change it to autodetect the hardware and to autoconfigure lircd.

> Lots of code duplication in kernel saved. 

Huh? The code is already there.

> What's the actual benefit of in-kernel decoding?

There are two benefits:

1) the developer that adds the hardware also adds the IR code. He has the hardware
and the IR for testing, so it means a faster development cycle than waiting for someone
else with the same hardware and IR to recode it on some other place. You should
remember that not all developers use lirc;

2) the IR works out of the box.

> 2. What would be the format of the key map? lircd.conf files already exist  
> for a lot of remote controls. Will we have a second incompatible format to  
> map the keys in-kernel? Where are the tools that create the key maps for  
> new remotes?

No matter what tool you use, the format should be very close: scancode -> key_code.

If you wan to take a look on a real example, I'm enclosing the keycode table used by
dib0700 driver, as generated/readed by a simple keycode application I made to test
the dynamic keycode loading:
	http://linuxtv.org/hg/v4l-dvb/file/tip/v4l2-apps/util/keytable.c

Most of the keycodes there are RC5 keys. There are also some NEC keys,
as those devices can work with either RC5 or NEC keycodes, by using a different
parameter during module load.

In the case of this driver, the pulse/space is done in hardware by the DibCom chip. The
scancode is sent to PC via the USB interface.

I hope it helps for you to better understand how this works.

Cheers,
Mauro.

--------------090801070503010302000504
Content-Type: text/plain;
 name="dib0700_rc_keys"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dib0700_rc_keys"

0x0700 KEY_MUTE
0x0701 KEY_MENU
0x0739 KEY_POWER
0x0703 KEY_VOLUMEUP
0x0709 KEY_VOLUMEDOWN
0x0706 KEY_CHANNELUP
0x070c KEY_CHANNELDOWN
0x070f KEY_1
0x0715 KEY_2
0x0710 KEY_3
0x0718 KEY_4
0x071b KEY_5
0x071e KEY_6
0x0711 KEY_7
0x0721 KEY_8
0x0712 KEY_9
0x0727 KEY_0
0x0724 KEY_SCREEN
0x072a KEY_TEXT
0x072d KEY_REWIND
0x0730 KEY_PLAY
0x0733 KEY_FASTFORWARD
0x0736 KEY_RECORD
0x073c KEY_STOP
0x073f KEY_CANCEL
0xeb01 KEY_POWER
0xeb02 KEY_1
0xeb03 KEY_2
0xeb04 KEY_3
0xeb05 KEY_4
0xeb06 KEY_5
0xeb07 KEY_6
0xeb08 KEY_7
0xeb09 KEY_8
0xeb0a KEY_9
0xeb0b KEY_VIDEO
0xeb0c KEY_0
0xeb0d KEY_REFRESH
0xeb0f KEY_EPG
0xeb10 KEY_UP
0xeb11 KEY_LEFT
0xeb12 KEY_OK
0xeb13 KEY_RIGHT
0xeb14 KEY_DOWN
0xeb16 KEY_INFO
0xeb17 KEY_RED
0xeb18 KEY_GREEN
0xeb19 KEY_YELLOW
0xeb1a KEY_BLUE
0xeb1b KEY_CHANNELUP
0xeb1c KEY_VOLUMEUP
0xeb1d KEY_MUTE
0xeb1e KEY_VOLUMEDOWN
0xeb1f KEY_CHANNELDOWN
0xeb40 KEY_PAUSE
0xeb41 KEY_HOME
0xeb42 KEY_MENU
0xeb43 KEY_SUBTITLE
0xeb44 KEY_TEXT
0xeb45 KEY_DELETE
0xeb46 KEY_TV
0xeb47 KEY_DVD
0xeb48 KEY_STOP
0xeb49 KEY_VIDEO
0xeb4a KEY_AUDIO
0xeb4b KEY_SCREEN
0xeb4c KEY_PLAY
0xeb4d KEY_BACK
0xeb4e KEY_REWIND
0xeb4f KEY_FASTFORWARD
0xeb54 KEY_PREVIOUS
0xeb58 KEY_RECORD
0xeb5c KEY_NEXT
0x1e00 KEY_0
0x1e01 KEY_1
0x1e02 KEY_2
0x1e03 KEY_3
0x1e04 KEY_4
0x1e05 KEY_5
0x1e06 KEY_6
0x1e07 KEY_7
0x1e08 KEY_8
0x1e09 KEY_9
0x1e0a KEY_KPASTERISK
0x1e0b KEY_RED
0x1e0c KEY_RADIO
0x1e0d KEY_MENU
0x1e0e KEY_GRAVE
0x1e0f KEY_MUTE
0x1e10 KEY_VOLUMEUP
0x1e11 KEY_VOLUMEDOWN
0x1e12 KEY_CHANNEL
0x1e14 KEY_UP
0x1e15 KEY_DOWN
0x1e16 KEY_LEFT
0x1e17 KEY_RIGHT
0x1e18 KEY_VIDEO
0x1e19 KEY_AUDIO
0x1e1a KEY_MEDIA
0x1e1b KEY_EPG
0x1e1c KEY_TV
0x1e1e KEY_NEXT
0x1e1f KEY_BACK
0x1e20 KEY_CHANNELUP
0x1e21 KEY_CHANNELDOWN
0x1e24 KEY_LAST
0x1e25 KEY_OK
0x1e29 KEY_BLUE
0x1e2e KEY_GREEN
0x1e30 KEY_PAUSE
0x1e32 KEY_REWIND
0x1e34 KEY_FASTFORWARD
0x1e35 KEY_PLAY
0x1e36 KEY_STOP
0x1e37 KEY_RECORD
0x1e38 KEY_YELLOW
0x1e3b KEY_GOTO
0x1e3d KEY_POWER
0x0042 KEY_POWER
0x077c KEY_TUNER
0x0f4e KEY_PRINT
0x0840 KEY_SCREEN
0x0f71 KEY_DOT
0x0743 KEY_0
0x0c41 KEY_1
0x0443 KEY_2
0x0b7f KEY_3
0x0e41 KEY_4
0x0643 KEY_5
0x097f KEY_6
0x0d7e KEY_7
0x057c KEY_8
0x0a40 KEY_9
0x0e4e KEY_CLEAR
0x047c KEY_CHANNEL
0x0f41 KEY_LAST
0x0342 KEY_MUTE
0x064c KEY_RESERVED
0x0172 KEY_SHUFFLE
0x0c4e KEY_PLAYPAUSE
0x0b70 KEY_RECORD
0x037d KEY_VOLUMEUP
0x017d KEY_VOLUMEDOWN
0x0242 KEY_CHANNELUP
0x007d KEY_CHANNELDOWN
0x1d00 KEY_0
0x1d01 KEY_1
0x1d02 KEY_2
0x1d03 KEY_3
0x1d04 KEY_4
0x1d05 KEY_5
0x1d06 KEY_6
0x1d07 KEY_7
0x1d08 KEY_8
0x1d09 KEY_9
0x1d0a KEY_TEXT
0x1d0d KEY_MENU
0x1d0f KEY_MUTE
0x1d10 KEY_VOLUMEUP
0x1d11 KEY_VOLUMEDOWN
0x1d12 KEY_CHANNEL
0x1d14 KEY_UP
0x1d15 KEY_DOWN
0x1d16 KEY_LEFT
0x1d17 KEY_RIGHT
0x1d1c KEY_TV
0x1d1e KEY_NEXT
0x1d1f KEY_BACK
0x1d20 KEY_CHANNELUP
0x1d21 KEY_CHANNELDOWN
0x1d24 KEY_LAST
0x1d25 KEY_OK
0x1d30 KEY_PAUSE
0x1d32 KEY_REWIND
0x1d34 KEY_FASTFORWARD
0x1d35 KEY_PLAY
0x1d36 KEY_STOP
0x1d37 KEY_RECORD
0x1d3b KEY_GOTO
0x1d3d KEY_POWER
0x8613 KEY_MUTE
0x8612 KEY_POWER
0x8601 KEY_1
0x8602 KEY_2
0x8603 KEY_3
0x8604 KEY_4
0x8605 KEY_5
0x8606 KEY_6
0x8607 KEY_7
0x8608 KEY_8
0x8609 KEY_9
0x8600 KEY_0
0x860d KEY_CHANNELUP
0x8619 KEY_CHANNELDOWN
0x8610 KEY_VOLUMEUP
0x860c KEY_VOLUMEDOWN
0x860a KEY_CAMERA
0x860b KEY_ZOOM
0x861b KEY_BACKSPACE
0x8615 KEY_ENTER
0x861d KEY_UP
0x861e KEY_DOWN
0x860e KEY_LEFT
0x860f KEY_RIGHT
0x8618 KEY_RECORD
0x861a KEY_STOP
0x7a00 KEY_MENU
0x7a01 KEY_RECORD
0x7a02 KEY_PLAY
0x7a03 KEY_STOP
0x7a10 KEY_CHANNELUP
0x7a11 KEY_CHANNELDOWN
0x7a12 KEY_VOLUMEUP
0x7a13 KEY_VOLUMEDOWN
0x7a40 KEY_POWER
0x7a41 KEY_MUTE

--------------090801070503010302000504--

Return-path: <mchehab@gaivota>
Received: from c6.93.b6.static.xlhost.com ([207.182.147.198]:60295 "EHLO
	sv20.byethost20.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab0KTDFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 22:05:45 -0500
Message-ID: <4CE73B01.2070108@chenopod.net>
Date: Sat, 20 Nov 2010 14:05:37 +1100
From: David Wilson <dnwilson@chenopod.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, dnwilson@chenopod.net
Subject: Re: [linux-dvb] DVB Driver for DiBcom's DiB7000M does not support
 the remote control for the kaiserbass TVStick
References: <4CDF716E.2090905@internode.on.net>
In-Reply-To: <4CDF716E.2090905@internode.on.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is my first attempt at working on a linux driver and I need some
assistance.

I have purchased the  kaiserbass TVStick product ID 'KBA01007-KB DVD-T
USB TUNER WITH 2 GB MEMORY'. The Linux-DVB Driver for DiBcom's DiB7000M
driver works very well for video, but the software driver does not
support the slim 28 key remote control provided by  kaiserbass.

The driver has support coded for several ir remote devices but not for
the unbranded slim 28 key one supplied with my tuner.

The  driver reports unrecognised remote key sequences it receives, for
example, the volume up key results in the system error message:

2010-11-14 13:07:26    Capulet    kernel    [10464.828505] dib0700:
Unknown remote controller key: 0000 2b d4

I tried adding a new set of key codes to the DiB7000M-devices.c file i.e.

{ 0x2bd4, KEY_VOLUMEUP },

and compiled and tested it but this did not work, the driver still
reports the keys as unrecognised. Perhaps I have used the wrong
conversion or format for the key values.

I have looked at the MS Windows driver configuration that came with the
tuner - modrc.infl, it defines the volume up key as:

HKR,,"ReportMappingTable",0x00000001,\
   \;0x01,<SystemMSB>,<SystemLSB>,<Data>, <Flags>, ...
....
 0x01,0x00,0x00,0x2C, 0x0B, 0x04,0x00,0x42,  \ ; AC volume up
......

I can not see the relationship between controller reported in the system
log - key: 0000 2b d4 and MS defined - 0x01,0x00,0x00,0x2C, 0x0B,
0x04,0x00,0x42

So there seems to de some some code conversion going on or incorrect
reporting of the key input.

Can anyone  assist me with this ?

regards

David Wilson

On 14/11/10 16:19, David Wilson wrote:
>
> I have purchased the  kaiserbass TVStick product ID 'KBA01007-KB DVD-T
> USB TUNER WITH 2 GB MEMORY'. The Linux-DVB Driver for DiBcom's
> DiB7000M driver works very well for video, but the software driver
> does not support the slim 28 key remote control provided by  kaiserbass.
>
> The evidence is the error codes in the system log. For example
> pressing any key causes a system log error, the volume up key results
> in the system error message:
>
> 2010-11-14 13:07:26    Capulet    kernel    [10464.828505] dib0700:
> Unknown remote controller key: 0000 2b d4
>
>            
> I tried adding a new set of key codes to the DiB7000M-devices.c file i.e.
>
> { 0x2bd4, KEY_VOLUMEUP },
>
> but this did not work, perhaps I have used the wrong conversion or
> format for the key values.
> Here are the key values from the system error messages
>
> KEY_MUTE            0AF5       
> KEY_SOURCE          38C7
> KEY_SCREEN          0FF0
> KEY_POWER           0CF3
> KEY_1               01FE
> KEY_2               02FD
> KEY_3               03FC
> KEY_4               04FB
> KEY_5               05FA
> KEY_6               06F9
> KEY_7               07F8
> KEY_8               08F7
> KEY_9               09F6
> KEY_0               00FF
> KEY_UP              20DF
> KEY_ESC             29D6
> KEY_FASTFORWARD     1EE1
> KEY_LEFT            11EE
> KEY_OK              0DF2
> KEY_RIGHT           10EF
> KEY_VOLUMEUP        2BD4
> KEY_CHANNELUP       12ED
> KEY_DOWN            21DE
> KEY_STOP            0BF4
> KEY_CHANNELDOWN     13EC
> KEY_VOLUMEDOWN      2CD3
> KEY_SCREEN_COPY     0EF1
> KEY_RECORD          1FEO
>
> regards
>
> David Wilson
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


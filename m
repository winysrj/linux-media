Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:25770 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab0AMIcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 03:32:52 -0500
Message-ID: <4B4D852F.4030506@skynet.be>
Date: Wed, 13 Jan 2010 09:32:47 +0100
From: xof <xof@skynet.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: VL4-DVB compilation issue not covered by Daily Automated
References: <4B4CE912.1000906@von-eitzen.de> <829197381001121344l3ad94bdajdd4eb0345b895f2b@mail.gmail.com>
In-Reply-To: <829197381001121344l3ad94bdajdd4eb0345b895f2b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller a écrit :
> On Tue, Jan 12, 2010 at 4:26 PM, Hagen von Eitzen <hagen@von-eitzen.de> wrote:
>   
>> Dear all,
>> as suggested by http://www.linuxtv.org/wiki/index.php/Bug_Report I report several warnings and errors not yet covered in latest http://www.xs4all.nl/~hverkuil/logs/Monday.log I get when compiling.
>> (The purpose of my experiments was trying to find out something about "0ccd:00a5 TerraTec Electronic GmbH")
>>
>> Regards
>> Hagen
>>     
>
> This is an Ubuntu-specific issue (they improperly packaged their
> kernel headers), which will not be covered by the daily build system
> (which exercises various kernels but not across different Linux
> distribution versions).
>
> Devin
>   
Are you sure? (it is an Ubuntu-only issue)

I can see several
> #include <asm/asm.h>
in the v4l tree that compile fine on Ubuntu
but only linux/drivers/media/dvb/firewire/firedtv-1394.c contains
> #include <asm.h>
and doesn't compile.

Unfortunately the asm.h asm/asm.h is not the only issue with
firedtv-1394.c (on Ubuntu/Karmic Koala?).
The /drivers/ieee1394/*.h seem to be in the linux-sources tree and not
in the linux-headers one (?)

Everywhere I look, I read "don't bother, just disable firedtv-1394.c"
until they fix it.

xof
---------------------
But my problem is 'I have no audio on an Hercules Smart TV 2 Stereo'
(bttv0: subsystem: 1540:952b; Card-100, Tuner-38).
It works on a Dapper LiveCD (with a good /etc/modprobe.d/bttv, a
~/.xawtv and xawtv installed).
The problem seems to exist since 2008...

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:45542 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZG2Fpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 01:45:52 -0400
Received: by ey-out-2122.google.com with SMTP id 9so140419eyd.37
        for <linux-media@vger.kernel.org>; Tue, 28 Jul 2009 22:45:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248834482.3377.3.camel@pc07.localdom.local>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <1248834482.3377.3.camel@pc07.localdom.local>
Date: Wed, 29 Jul 2009 07:45:51 +0200
Message-ID: <d9def9db0907282245v4e6f332ha4b5bb28ce5972f2@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Markus Rechberger <mrechberger@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>, efa@iol.it,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 29, 2009 at 4:28 AM, hermann pitton<hermann-pitton@arcor.de> wrote:
> Hi,
>
> Am Dienstag, den 28.07.2009, 20:44 -0400 schrieb Devin Heitmueller:
>> On Tue, Jul 28, 2009 at 7:32 PM, Valerio Messina<efa@iol.it> wrote:
>> > hi all,
>> >
>> > I own a Terratec Cinergy HibridT XS
>> > with lsusb ID:
>> > Bus 001 Device 007:
>> > ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS
>> >
>> > With past kernel and a patch as suggested here:
>> > http://www.linuxtv.org/wiki/index.php/TerraTec
>> > that link to:
>> > http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
>> > that link to:
>> > http://mcentral.de/wiki/index.php5/Main_Page
>> > and some troubles for Ubuntu kernel that I solved here:
>> > https://bugs.launchpad.net/bugs/322732
>> > worked well for a year or more.
>> >
>> > With last Ubuntu 9.04, kernel 2.6.28-13 seems have native support for the
>> > tuner, but from dmesg a file is missing: xc3028-v27.fw
>> > (maybe manage I2C for IR?)
>> > I found it on a web site, copied in /lib/firmware
>> > and now Kaffeine work, but ... no more IR remote command work.
>> >
>> > More bad now:
>> > http://mcentral.de/wiki/index.php5/Installation_Guide
>> > sell TV tuner, and do not support anymore the Terratec tuner, the source
>> > repository is disappeared, and install instruction is a commercial.
>
> all in all it is really funny.
>
>> > Any chanches?
>> >
>> > thanks in advace,
>> > Valerio
>>
>> That device, including full support for the IR, is now supported in
>> the mainline v4l-dvb tree (and will appear in kernel 2.6.31).  Just
>> follow the directions here to get the code:
>>
>> http://linuxtv.org/repo
>>
>> Devin
>>
>
> Hopefully nobody is mad enough to buy for such prices.
>

compared with other drivers it has some big advantages, eg. automatic
audio routing (supports OSS/Alsa/reading audio external) - as tvtime
doesn't support audio at all our solution automatically enables audio
with it, installation works within a few seconds (everywhere, any
distribution, eg eeepc, acer aspire one, ubuntu, redhat, suse..),
kernel independent, more or less unix operating system independent as
well.
There's nothing comparable available, and it has full support from the
chipdesign companies, just about anyone who doesn't know much about
linux can easily handle it without the knowledge how to set up a
development system. CI Support is on the roadmap as well for DVB-C.
While all of that it is still compatible to existing kernel drivers.
Updates will also affect all systems at once and won't need a
particular kernel versions.
So it is more like a question if someone wants a prebuilt, working car
which has guaranteed support, or wants to build his own car both is
doable of course.

Best Regards,
Markus

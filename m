Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3CECaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 21:30:35 -0500
Date: Mon, 4 Mar 2013 23:30:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130304233028.7bc3c86c@redhat.com>
In-Reply-To: <51353591.4040709@netscape.net>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
	<20130303134051.6dc038aa@redhat.com>
	<20130304164234.18df36a7@redhat.com>
	<51353591.4040709@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 04 Mar 2013 21:00:17 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi all
> 
> El 04/03/13 16:42, Mauro Carvalho Chehab escribió:
> > Em Sun, 3 Mar 2013 13:40:51 -0300
> > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> >
> >> Em Sun, 03 Mar 2013 11:50:25 -0300
> >> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
> >>
> >>
> >>> The new data replacement in mb86a20s
> >>>
> >>> /*
> >>>    * Initialization sequence: Use whatevere default values that PV SBTVD
> >>>    * does on its initialisation, obtained via USB snoop
> >>>    */
> >>> static struct regdata mb86a20s_init[] = {
> >> Please test first my mb86a20s patchset. If it doesn't work, we'll need
> >> to dig into the differences.
> >>
> >> The better is to group these and reorder them to look like what's there
> >> at the driver, and send it like a diff. That would make a way easier to
> >> see what's different there.
> >>
> >> Anyway, it follows my comments about a few things that came into my eyes.
> >>
> >>>       { 0x09, 0x3a },
> >> No idea what's here, but it seems a worth trial to change it.
> > It controls inversion. I just pushed a patch that will let it handle
> > both normal and inverted spectrum. The DVB core will automatically
> > switch inversion during device tuning.
> 
> I test, but not work.
> 
> Before the latest patches, obtained as follows, for example:
> 
> dmesg
> [  397.076641] mb86a20s: mb86a20s_read_status:
> [  397.077129] mb86a20s: mb86a20s_read_status: val = X, status = 0xXX

I did a cleanup at the printk messages. Also, the debug ones now use
dynamic_printk. That means that they're disabled by default. They can
be enabled in runtime (and per-line). If you want to enable all messages,
you can do:

To enable all debug messages on mb86a20s:
	echo "file drivers/media/dvb-frontends/mb86a20s.c +p" > /sys/kernel/debug/dynamic_debug/control

To clean all debug messages
	echo "-p" > /sys/kernel/debug/dynamic_debug/control

To enable just the *ber* or *BER* ones:
	
	for i in $(cat /sys/kernel/debug/dynamic_debug/control|grep mb86a20s.c|grep -i ber|cut -d' ' -f 1|cut -d: -f2); do
		echo "file drivers/media/dvb-frontends/mb86a20s.c line $i +p" > /sys/kernel/debug/dynamic_debug/control
	done


> and now, I don't get anything. But if I use VLC I get this:
> 
> 
> dtvdebug: frontend status: 0x00
> 
> dtvdebug: frontend status: 0x03
> 
> dtvdebug: frontend status: 0x07
> 
> dtvdebug: frontend status: 0x01

Ok, that means that it is trying to sync Viterbi. You're better served if you
use dvbv5-scan[1], instead, as it will provide you more information (eventually
CNR - if it can keep status = 0x07 for a while, or if you have a zap file:

$ dvbv5-zap -I zap  -c ~/isdb_channel.conf "globo 1seg"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file '/home/mchehab/isdb_channel.conf'
tuning to 485142857 Hz
video pid 529
  dvb_set_pesfilter 529
audio pid 530
  dvb_set_pesfilter 530
RF     (0x01) Signal= 0.00%
RF     (0x01) Signal= 0.00%
RF     (0x01) Signal= 0.00%
Carrier(0x03) Signal= 0.00%
RF     (0x01) Signal= 0.00%
RF     (0x01) Signal= 0.00%
Lock   (0x1f) Quality= Poor Signal= 6.25% C/N= 15.57dB UCB= 96965 postBER= 0 preBER= 3.08x10^-3 PER= 1.00
	  Layer A: Quality= Poor C/N= 15.52dB UCB= 4064 postBER= 0 preBER= 3.08x10^-3 PER= 1.00
	  Layer B: C/N= 30.00dB

I think I asked it already, but eventually, it is just antenna. 

[1] http://git.linuxtv.org/v4l-utils.git/blob/192d27e53f09924e9ec3150ae146df86da178f02:/utils/dvb/dvbv5-scan.c

> >>>       { 0x28, 0x2a },
> >>>       { 0x29, 0x00 },
> >>>       { 0x2a, 0xfd },
> >>>       { 0x2b, 0xc8 },
> >> Hmm... the above may explain why it is not working. This is calculated
> >> from the XTAL frequency, and IF (if different than 4MHz).
> >>
> >> Just changing it could fix the issue.
> > I also added a patch that allows using a different XTAL frequency.
> >
> > You can use the calculus there to convert from 0x00fdc8 into the XTAL
> > frequency, if you have the IF set by xc5000.
> I don't have the IF. How I can know the intermediate frequency?
> 
> Xtal near of xc5000 is 32.000MHz. Perhaps 32/8=4 -->IF

The easiest way to discover is to enable the mb86a20s debug:

[ 1443.564782] i2c i2c-3: mb86a20s_initfe: fclk=32571428, IF=4000000, clock reg=0x00ff80
[ 1443.566781] i2c i2c-3: mb86a20s_initfe: IF=4000000, IF reg=0x3ee08f

The IF here come from the tuner, via ops.get_if_frequency().

> There are other 2 xtal of 16.000MHz and other of 28.636MHz.

> Xtal of mb86a20s is 32.571MHz.

That seems to be the standard xtal. 

> In total there are 4 xtal.
> 
> With mb86a20s changes made, the logs (i2c traffic) obtained are 
> different from those obtained with Windows
> 
> I have yet to thoroughly analyze 24 samples I took with the logic 
> analyzer and try to see your logic. This is going to take some time.
> 
> 
> Again thank you very much,
> 
> Alfredo


-- 

Cheers,
Mauro

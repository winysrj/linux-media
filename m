Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33555 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbZG0Kq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 06:46:26 -0400
Received: by fxm18 with SMTP id 18so2505821fxm.37
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2009 03:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907261547.24281.liplianin@me.by>
References: <79fc70d20907221001v3a56a142v445d9167197ecf0d@mail.gmail.com>
	 <200907222307.25701.liplianin@me.by>
	 <79fc70d20907251512i3cf15f57n1c2d653b18cba085@mail.gmail.com>
	 <200907261547.24281.liplianin@me.by>
Date: Mon, 27 Jul 2009 11:46:24 +0100
Message-ID: <79fc70d20907270346l351c3aacidb9f7935c3332b26@mail.gmail.com>
Subject: Re: [linux-dvb] Help Request: DM1105 STV0299 DVB-S PCI - Unable to
	tune
From: Shaun Murdoch <scrauny@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Simon Kenyon <simon@koala.ie>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the help so far. I did a hg clone of the latest v4l-dvb
repository, built, installed, rebooted a few times, and did the
modprobe below, but unfortunately I still can't lock:

Here's the scan output:

$ sudo ../scan -vvvvvvv test
scanning test
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 11220000 H 27500000 2
>>> tune to: 11220:h:0:27500
DiSEqC: switch pos 0, 18V, loband (index 1)
diseqc_send_msg:59: DiSEqC: e0 10 38 f2 00 00
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
WARNING: >>> tuning failed!!!
>>> tune to: 11220:h:0:27500 (tuning failed)

Interestingly, since changing the drivers, the STV0299 is mapping
against a weird frontend:
[   12.633254] DVB: registering adapter 0 frontend 28036848 (ST
STV0299 DVB-S)...

Could this be a problem?

Thanks,
Shaun



2009/7/26 Igor M. Liplianin <liplianin@me.by>:
> On 26 ÉÀÌÑ 2009 01:12:14 Shaun Murdoch wrote:
>> Hi Igor,
>>
>> I've taken some photos of the tuner so that hopefully you'll be able
>> to help work out why it won't tune in Linux.
>>
>> Please see the following link for the images:
>> http://www.flickr.com/photos/7690303@N04/sets/72157621703527801/
> I have a few dm1105 based cards, but yours looks different from mine.
>
>>
>> The only chip on display is:
>> SDMC
>> DM1105N
>> D735 šE280034
> Please try recent v4l-dvb, as I've commited some change.
> Now You can try
> š š š šmodprobe dm1105 card=1
>>
>> Also - I tested the card in a Windows box today, so I am now certain
>> that both the card and the satellite connection are OK. The settings
>> that work with Windows (frequency, etc), don't lock in Linux. (I do
>> get a good signal reading in Kaffeine that is the same as Windows
>> gives, but no lock.)
>>
>> I hope this will help you work out what is wrong.
>>
>> Thanks!
>> Shaun
>>
>> 2009/7/22 Igor M. Liplianin <liplianin@me.by>:
>> > On 22 ÉÀÌÑ 2009 21:43:01 Shaun Murdoch wrote:
>> >> Hi,
>> >>
>> >> Thanks for the suggestion.
>> >>
>> >> I think there's something a bit weird with dvbtune. According to it's
>> >> man page the units for frequency (-f) are Hz. I am trying to tell it
>> >> 11.778 GHz - but you get errors if you do -f 11778000000. Equally you
>> >> also get errors if you assume it is MHz, i.e. -f 11778. š Anyway, if
>> >> it prints FE_HAS_SIGNAL and FE_HAS_CARRIER that must mean the
>> >> frequency I gave it is OK?
>> >>
>> >> In any case, scan doesn't work, nor does Kaffeine, so I don't think
>> >> it's that my use of dvbtune is wrong.
>> >>
>> >> Anyone got any other suggestions on what I can do to get this to lock?
>> >>
>> >> Thanks,
>> >> Shaun
>> >>
>> >> 2009/7/22 Seyyed Mohammad mohammadzadeh <softnhard.es@gmail.com>:
>> >> > Hello,
>> >> >
>> >> > I don't know what is the exact cause of your problem but I think you
>> >> > are tuning to a wrong frequency. You wrote:
>> >> >
>> >> > šdvbtune -f 1177800 -s 27500 -p v -m
>> >> >
>> >> > in which the frequency parameters has two extra zeros which cause the
>> >> > frequency to interpret as : 1,177,800 MHz !!!!!!!
>> >> >
>> >> > 2009/7/22 Shaun Murdoch <scrauny@gmail.com>
>> >> >
>> >> >> Hi everyone,
>> >> >> First post so please be gentle :-)
>> >> >> I was wondering if anyone can help me please - I am trying to get a
>> >> >> DVB-S PCI card working with Linux (Ubuntu 9.04). So far I can get the
>> >> >> card recognised by Linux, but it won't tune - Kaffeine does tell me
>> >> >> that there is 95% signal and 80% SNR, and I am using the same
>> >> >> frequencies etc that a standard Sky box uses. The card is very common
>> >> >> on eBay so I am sure there are plenty people who have tried this /
>> >> >> would want this working. Some details that I hope will help someone
>> >> >> who knows more than I do about this! The card is one of these:
>> >> >> http://cgi.ebay.co.uk/DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card
>> >> >>-Re
>> >> >> mote_W0QQitemZ130314645048QQcmdZViewItemQQptZUK_Computing_Computer_Co
>> >> >>mpon
>> >> >> ents_Graphics_Video_TV_Cards_TW?hash=item1e575bae38&_trksid=p3286.c0.
>> >> >>m14& _trkparms=65:12|66:2|39:1|72:1690|293:1|294:50 lspci:
>> >> >> 03:09.0 Ethernet controller: Device 195d:1105 (rev 10)
>> >> >> My dmesg output - looks ok?:
>> >> >>
>> >> >> $ dmesg | grep DVB
>> >> >> [ š 12.174738] DVB: registering new adapter (dm1105)
>> >> >> [ š 12.839501] DVB: registering adapter 0 frontend 0 (ST STV0299
>> >> >> DVB-S)... [ š 12.839633] input: DVB on-card IR receiver as
>> >> >> /devices/pci0000:00/0000:00:1e.0/0000:03:09.0/input/input
>> >> >>
>> >> >> My output from scan - the problem:
>> >> >>
>> >> >> $ sudo scan -vvvvvv /usr/share/dvb/dvb-s/Astra-28.2E
>> >> >> scanning /usr/share/dvb/dvb-s/Astra-28.2E
>> >> >> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> >> >>
>> >> >> >>> tune to: 11778:v:0:27500
>> >> >>
>> >> >> DiSEqC: switch pos 0, 13V, hiband (index 2)
>> >> >> diseqc_send_msg:56: DiSEqC: e0 10 38 f1 00 00
>> >> >> DVB-S IF freq is 1178000
>> >> >>
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >> >>> tuning status == 0x03
>> >> >>
>> >> >> WARNING: >>> tuning failed!!!
>> >> >>
>> >> >> This is the correct satellite for my location (south UK), I believe.
>> >> >> Have tried plenty. Nothing locks. I'm using the latest liplianin
>> >> >> drivers - did a mercurial checkout and build today:
>> >> >>
>> >> >> $ modinfo dm1105
>> >> >> filename:
>> >> >> /lib/modules/2.6.28-13-server/kernel/drivers/media/dvb/dm1105/dm1105.
>> >> >>ko license: š š š šGPL
>> >> >> description: š šSDMC DM1105 DVB driver
>> >> >> author: š š š š Igor M. Liplianin <liplianin@me.by>
>> >> >> srcversion: š š 46C1B3C3627D1937F75D732
>> >> >> alias: š š š š špci:v0000195Dd00001105sv*sd*bc*sc*i*
>> >> >> alias: š š š š špci:v0000109Fd0000036Fsv*sd*bc*sc*i*
>> >> >> depends: š š š šir-common,dvb-core
>> >> >> vermagic: š š š 2.6.28-13-server SMP mod_unload modversions
>> >> >> parm: š š š š š card:card type (array of int)
>> >> >> parm: š š š š š ir_debug:enable debugging information for IR decoding
>> >> >> (int) parm: š š š š š adapter_nr:DVB adapter numbers (array of short)
>> >> >>
>> >> >> Have also tried the latest v4l-dvb drivers and get exactly the same
>> >> >> tuning problems. Finally, dvbtune appears to say I have signal but
>> >> >> cannot lock:
>> >> >>
>> >> >> $ sudo dvbtune -f 1177800 -s 27500 -p v -m -tone 1 -vvvvvvvvvvv
>> >> >> [sudo] password for shaun:
>> >> >> Using DVB card "ST STV0299 DVB-S"
>> >> >> tuning DVB-S to L-Band:0, Pol:V Srate=27500000, 22kHz=on
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS:
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> >> >> polling....
>> >> >> Getting frontend event
>> >> >> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>> >> >>
>> >> >> So I am thinking that this could be a driver issue? If the card has
>> >> >> good signal and SNR in Kaffeine, and dvbtune says it has signal and
>> >> >> carrier - but cannot lock? Please can someone help me debug this?
>> >> >> Thanks a lot!
>> >> >> Shaun
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >> _______________________________________________
>> >> >> linux-dvb users mailing list
>> >> >> For V4L/DVB development, please use instead
>> >> >> linux-media@vger.kernel.org linux-dvb@linuxtv.org
>> >> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>> >> >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-media"
>> >> > in the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> >> in the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>> >
>> > Hi Shaun,
>> > Did you read something on tuner can?
>> > Or maybe you take a picture of tuner can without cover.
>> > Also close look picture of card would be nice.
>> > Though definately demod is stv0299, but tuner chip may be different.
>> > I suspect it is stb6000, but such combination(stb6000 + stv0299) not
>> > supported in the driver now. Anyway, you can try modprobe dm1105 with
>> > parameter card=1 from s2-liplianin tree.
>> >
>> > Igor
>
> --
> Igor M. Liplianin
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:25497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZGWJxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 05:53:42 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1067470fga.17
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 02:53:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A683183.5030904@koala.ie>
References: <79fc70d20907221001v3a56a142v445d9167197ecf0d@mail.gmail.com>
	 <4A683183.5030904@koala.ie>
Date: Thu, 23 Jul 2009 10:53:41 +0100
Message-ID: <79fc70d20907230253m16fb5ef9j524304796f45049f@mail.gmail.com>
Subject: Re: [linux-dvb] Help Request: DM1105 STV0299 DVB-S PCI - Unable to
	tune
From: Shaun Murdoch <scrauny@gmail.com>
To: Simon Kenyon <simon@koala.ie>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Simon - did you need to do anything special to get them to
work, or did they work out of the box with the latest s2-liplianin /
v4l-dvb drivers?

I've not tried another card (don't have one), but I did try a set-top
box which works fine - and let me get the frequency/lnb/etc info.


2009/7/23 Simon Kenyon <simon@koala.ie>:
> Shaun Murdoch wrote:
>>
>> Hi everyone,
>>
>> First post so please be gentle :-)
>>
>> I was wondering if anyone can help me please - I am trying to get a DVB-S
>> PCI card working with Linux (Ubuntu 9.04). So far I can get the card
>> recognised by Linux, but it won't tune - Kaffeine does tell me that there is
>> 95% signal and 80% SNR, and I am using the same frequencies etc that a
>> standard Sky box uses.
>>
>> The card is very common on eBay so I am sure there are plenty people who
>> have tried this / would want this working.
>>
>> Some details that I hope will help someone who knows more than I do about
>> this!
>>
>> The card is one of these:
>>
>> http://cgi.ebay.co.uk/DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card-Remote_W0QQitemZ130314645048QQcmdZViewItemQQptZUK_Computing_Computer_Components_Graphics_Video_TV_Cards_TW?hash=item1e575bae38&_trksid=p3286.c0.m14&_trkparms=65:12|66:2|39:1|72:1690|293:1|294:50
>> <http://cgi.ebay.co.uk/DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card-Remote_W0QQitemZ130314645048QQcmdZViewItemQQptZUK_Computing_Computer_Components_Graphics_Video_TV_Cards_TW?hash=item1e575bae38&_trksid=p3286.c0.m14&_trkparms=65:12%7C66:2%7C39:1%7C72:1690%7C293:1%7C294:50>
>>
>> lspci:
>> 03:09.0 Ethernet controller: Device 195d:1105 (rev 10)
>>
>> My dmesg output - looks ok?:
>> $ dmesg | grep DVB
>> [   12.174738] DVB: registering new adapter (dm1105)
>> [   12.839501] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
>> [   12.839633] input: DVB on-card IR receiver as
>> /devices/pci0000:00/0000:00:1e.0/0000:03:09.0/input/input
>>
>> My output from scan -* the problem*:
>> $ sudo scan -vvvvvv /usr/share/dvb/dvb-s/Astra-28.2E
>> scanning /usr/share/dvb/dvb-s/Astra-28.2E
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>
>> >>> tune to: 11778:v:0:27500
>> DiSEqC: switch pos 0, 13V, hiband (index 2)
>> diseqc_send_msg:56: DiSEqC: e0 10 38 f1 00 00
>> DVB-S IF freq is 1178000
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> >>> tuning status == 0x03
>> WARNING: >>> tuning failed!!!
>> /This is the correct satellite for my location (south UK), I believe. Have
>> tried plenty. Nothing locks./
>>
>> I'm using the latest liplianin drivers - did a mercurial checkout and
>> build today:
>> $ modinfo dm1105
>> filename:
>> /lib/modules/2.6.28-13-server/kernel/drivers/media/dvb/dm1105/dm1105.ko
>> license:        GPL
>> description:    SDMC DM1105 DVB driver
>> author:         Igor M. Liplianin <liplianin@me.by
>> <mailto:liplianin@me.by>>
>> srcversion:     46C1B3C3627D1937F75D732
>> alias:          pci:v0000195Dd00001105sv*sd*bc*sc*i*
>> alias:          pci:v0000109Fd0000036Fsv*sd*bc*sc*i*
>> depends:        ir-common,dvb-core
>> vermagic:       2.6.28-13-server SMP mod_unload modversions
>> parm:           card:card type (array of int)
>> parm:           ir_debug:enable debugging information for IR decoding
>> (int)
>> parm:           adapter_nr:DVB adapter numbers (array of short)
>> Have also tried the latest v4l-dvb drivers and get exactly the same tuning
>> problems.
>>
>> Finally, dvbtune appears to say I have signal but cannot lock:
>> $ sudo dvbtune -f 1177800 -s 27500 -p v -m -tone 1 -vvvvvvvvvvv
>> [sudo] password for shaun:
>> Using DVB card "ST STV0299 DVB-S"
>> tuning DVB-S to L-Band:0, Pol:V Srate=27500000, 22kHz=on
>> polling....
>> Getting frontend event
>> FE_STATUS:
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>> polling....
>> Getting frontend event
>> FE_STATUS: *FE_HAS_SIGNAL FE_HAS_CARRIER* FE_HAS_VITERBI
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>>
>> So I am thinking that this could be a driver issue? If the card has good
>> signal and SNR in Kaffeine, and dvbtune says it has signal and carrier - but
>> cannot lock?
>>
>> Please can someone help me debug this?
>>
>> Thanks a lot!
>> Shaun
>
> i have a few and they work fine
> in my small little way i helped to get them to work
> in fact i tried to import a bulk shipment from china - but they offered the
> same price for 200 as i can get on ebay - so i didn't bother
>
> are you sure the signal is good? have you tried with another card to check?
> --
> simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

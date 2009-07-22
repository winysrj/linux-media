Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:6836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZGVSnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:43:02 -0400
Received: by fg-out-1718.google.com with SMTP id e12so964523fga.17
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 11:43:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d2f7e03e0907221018t53077d2dq1a530670c79320f1@mail.gmail.com>
References: <79fc70d20907221001v3a56a142v445d9167197ecf0d@mail.gmail.com>
	 <d2f7e03e0907221018t53077d2dq1a530670c79320f1@mail.gmail.com>
Date: Wed, 22 Jul 2009 19:43:01 +0100
Message-ID: <79fc70d20907221143l530692d3hfaaa1f9a9a4a6be@mail.gmail.com>
Subject: Re: [linux-dvb] Help Request: DM1105 STV0299 DVB-S PCI - Unable to
	tune
From: Shaun Murdoch <scrauny@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the suggestion.

I think there's something a bit weird with dvbtune. According to it's
man page the units for frequency (-f) are Hz. I am trying to tell it
11.778 GHz - but you get errors if you do -f 11778000000. Equally you
also get errors if you assume it is MHz, i.e. -f 11778.   Anyway, if
it prints FE_HAS_SIGNAL and FE_HAS_CARRIER that must mean the
frequency I gave it is OK?

In any case, scan doesn't work, nor does Kaffeine, so I don't think
it's that my use of dvbtune is wrong.

Anyone got any other suggestions on what I can do to get this to lock?

Thanks,
Shaun


2009/7/22 Seyyed Mohammad mohammadzadeh <softnhard.es@gmail.com>:
> Hello,
>
> I don't know what is the exact cause of your problem but I think you
> are tuning to a wrong frequency. You wrote:
>
>  dvbtune -f 1177800 -s 27500 -p v -m
>
> in which the frequency parameters has two extra zeros which cause the
> frequency to interpret as : 1,177,800 MHz !!!!!!!
>
> 2009/7/22 Shaun Murdoch <scrauny@gmail.com>
>>
>> Hi everyone,
>> First post so please be gentle :-)
>> I was wondering if anyone can help me please - I am trying to get a DVB-S PCI card working with Linux (Ubuntu 9.04). So far I can get the card recognised by Linux, but it won't tune - Kaffeine does tell me that there is 95% signal and 80% SNR, and I am using the same frequencies etc that a standard Sky box uses.
>> The card is very common on eBay so I am sure there are plenty people who have tried this / would want this working.
>> Some details that I hope will help someone who knows more than I do about this!
>> The card is one of these:
>> http://cgi.ebay.co.uk/DVB-S-Satellite-TV-Tuner-Video-Capture-PCI-Card-Remote_W0QQitemZ130314645048QQcmdZViewItemQQptZUK_Computing_Computer_Components_Graphics_Video_TV_Cards_TW?hash=item1e575bae38&_trksid=p3286.c0.m14&_trkparms=65:12|66:2|39:1|72:1690|293:1|294:50
>> lspci:
>> 03:09.0 Ethernet controller: Device 195d:1105 (rev 10)
>> My dmesg output - looks ok?:
>>
>> $ dmesg | grep DVB
>> [   12.174738] DVB: registering new adapter (dm1105)
>> [   12.839501] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
>> [   12.839633] input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:1e.0/0000:03:09.0/input/input
>>
>> My output from scan - the problem:
>>
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
>>
>> This is the correct satellite for my location (south UK), I believe. Have tried plenty. Nothing locks.
>> I'm using the latest liplianin drivers - did a mercurial checkout and build today:
>>
>> $ modinfo dm1105
>> filename:       /lib/modules/2.6.28-13-server/kernel/drivers/media/dvb/dm1105/dm1105.ko
>> license:        GPL
>> description:    SDMC DM1105 DVB driver
>> author:         Igor M. Liplianin <liplianin@me.by>
>> srcversion:     46C1B3C3627D1937F75D732
>> alias:          pci:v0000195Dd00001105sv*sd*bc*sc*i*
>> alias:          pci:v0000109Fd0000036Fsv*sd*bc*sc*i*
>> depends:        ir-common,dvb-core
>> vermagic:       2.6.28-13-server SMP mod_unload modversions
>> parm:           card:card type (array of int)
>> parm:           ir_debug:enable debugging information for IR decoding (int)
>> parm:           adapter_nr:DVB adapter numbers (array of short)
>>
>> Have also tried the latest v4l-dvb drivers and get exactly the same tuning problems.
>> Finally, dvbtune appears to say I have signal but cannot lock:
>>
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
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER FE_HAS_VITERBI
>> polling....
>> Getting frontend event
>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>>
>> So I am thinking that this could be a driver issue? If the card has good signal and SNR in Kaffeine, and dvbtune says it has signal and carrier - but cannot lock?
>> Please can someone help me debug this?
>> Thanks a lot!
>> Shaun
>>
>>
>>
>>
>>
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

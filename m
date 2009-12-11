Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46294 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbZLKQsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 11:48:15 -0500
Received: by ewy1 with SMTP id 1so1266667ewy.28
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 08:48:20 -0800 (PST)
Message-ID: <4B2277E8.5080702@flumotion.com>
Date: Fri, 11 Dec 2009 17:48:40 +0100
From: =?UTF-8?B?R3VpbGxlbSBTb2zDoA==?= <garanda@flumotion.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: TveiiS470 and DVBWorld2005 not working
References: <4B21260D.9080408@flumotion.com>	 <200912102035.59356.liplianin@me.by> <59335d7a0912110247m2c10844eucead2ac534d502cf@mail.gmail.com>
In-Reply-To: <59335d7a0912110247m2c10844eucead2ac534d502cf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guillem Aranda wrote:
> Sorry for the noise,
>
> The sooner I wrote the email, the sooner my TeviiS470 started to work!
>
> I did it work with the latest s2-liplianin tip, of course firmwares 
> were in /lib/firmware dir.
>
> Now I'm doing some compatibility tests. As I said I can get a few less 
> channels than with the saa7164 that I'm using in old computers.
>
> My aim is to certify it for the company I work for, so if there is 
> something I could do testing it to help the community, I could do it 
> during my work journey.
>
> regards,
>
> Guillem
>
>
> On Thu, Dec 10, 2009 at 7:35 PM, Igor M. Liplianin <liplianin@me.by 
> <mailto:liplianin@me.by>> wrote:
>
>     On 10 декабря 2009 18:47:09 Guillem Solà wrote:
>     > Hi,
>     >
>     > I come to this list as my last resort. I have two DVB-S PCIE
>     cards and
>     > no one can get channels, but I have another computer with a PCI
>     SAA7146
>     > that can get 1400 services from same dish.
>     >
>     > * Tveii S470 *
>     >
>     > One is the Tveii S470. I guess that the S470 should work because
>     you are
>     > working in IR support.
>     >
>     > I have tried V4L tip, drivers from website, from website and patched
>     > like in wiki says... but all I get is:
>     >
>     > scandvb -a 0 /usr/share/dvb-apps/dvb-s/Astra-19.2E
>     >
>     > scanning /usr/share/dvb-apps/dvb-s/Astra-19.2E
>     > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>     > initial transponder 12551500 V 22000000 5
>     >
>     >  >>> tune to: 12551:v:0:22000
>     >
>     > WARNING: filter timeout pid 0x0011
>     > WARNING: filter timeout pid 0x0000
>     > WARNING: filter timeout pid 0x0010it's going on
>     >
>     > dumping lists (0 services)
>     >
>     > Done.
>     >
>     >
>     > * DVBWorld 2005 *
>     >
>     > The other is the DVBWorld DVB-S2 2005. I have tried also latest V4l,
>     > liplianin branch... and I get the same: 0 services.
>     >
>     >
>     > The hardware were I'm trying to run this is a Dell 1 unit Rack
>     Server
>     > with RHEL with kernels 2.6.30, 2.6.31 and 2.6.32 patched by myself.
>     >
>     > As I said I have another computer with a PCI dvb-s card that can
>     get lot
>     > of channels so I thing that the disk is working well.
>     >
>     >
>     > Any idea about what's going on?
>     Hi Guillem,
>     I think you are missing firmwares, though you give too little
>     information.
>
>     >
>     > Thanks in advance,
>     >
>     > Guillem Solà
>     > --
>     > To unsubscribe from this list: send the line "unsubscribe
>     linux-media" in
>     > the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>     --
>     Igor M. Liplianin
>     Microsoft Windows Free Zone - Linux used for all Computing Tasks
>
>
Hi,

I have been testing my TeviiS470 against the saa7164 and basically what 
I get is that the signal and s/n ratio is lower tuning from the same 
dish with TeviiS470.

For example tuning the same channel on each one and comparing the femon 
output:

On saa7164 AragonTv from Astra works well

FE: ST STV0299 DVB-S (SAT)
status 1f | signal e600 | snr edba | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e4c0 | snr ed84 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e73e | snr ed5a | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e607 | snr ed0c | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e608 | snr ee02 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e607 | snr edf3 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

On TeviiS470 the same channel have some problems :

FE: Montage Technology DS3000/TS2020 (SAT)
status 1f | signal 9088 | snr 51e0 | ber 00000000 | unc 00001010 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 00003f67 | unc 00005669 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 0000400e | unc 000056ed | 
FE_HAS_LOCK
status 00 | signal 9088 | snr 51e0 | ber 00003f84 | unc 000056ec |
status 1f | signal 9088 | snr 51e0 | ber 00003ebb | unc 000056cb | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 00004057 | unc 00005507 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 00004083 | unc 000056d1 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 00003e63 | unc 000056bc | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 51e0 | ber 00003fe9 | unc 000056be | 
FE_HAS_LOCK



Here femon output of a channel that works better than the last one

FE: Montage Technology DS3000/TS2020 (SAT)
status 1f | signal 9088 | snr 7ad0 | ber 000002dc | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 7ad0 | ber 0000024a | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 8f48 | ber 00000262 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 8f48 | ber 00000314 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 8f48 | ber 000002db | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 8f48 | ber 000002ed | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 9088 | snr 8f48 | ber 000003a3 | unc 00000000 | 
FE_HAS_LOCK

FE: ST STV0299 DVB-S (SAT)
status 1f | signal eafb | snr e835 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ec38 | snr e820 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal eafe | snr e7c9 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal eafd | snr e7d2 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e9c2 | snr e7d8 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal ec39 | snr e7d8 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal eaf4 | snr e7e4 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal eaf3 | snr e7b7 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK


Basically that's what happens on all the channels I tried, the signal 
strength and s/n ratio is lower with TeviiS470 than with saa7164.

regards,

Guillem

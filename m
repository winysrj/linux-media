Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:41143 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0FFU7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 16:59:39 -0400
Date: Sun, 6 Jun 2010 22:59:36 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: Niels Wagenaar <n.wagenaar@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] hvr4000 doesnt work w/ dvb-s2 nor DVB-T
Message-ID: <20100606225936.3eb0376d@romy.gusto>
In-Reply-To: <AANLkTilkO8i2e_SyHVVqYuaPEhjm95VmHHpiABFQc_Rj@mail.gmail.com>
References: <20100606010311.6d98ef7b@romy.gusto>
	<20100606084301.GA3070@gmail.com>
	<20100606133946.76c3a6e0@romy.gusto>
	<20100606124925.GB3070@gmail.com>
	<20100606145154.60de422e@romy.gusto>
	<20100606125636.GC3070@gmail.com>
	<20100606150554.55be1852@romy.gusto>
	<AANLkTin1jaMbG0ULhQRZi3QWkd2oVXazJ4BTGh5rMYdM@mail.gmail.com>
	<20100606212814.1e55206c@romy.gusto>
	<AANLkTilLnzSddnbyCn0QawNwvQkeFsWK_RvkgNPH4Gyx@mail.gmail.com>
	<20100606215906.1c1f5536@romy.gusto>
	<AANLkTilkO8i2e_SyHVVqYuaPEhjm95VmHHpiABFQc_Rj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

and lets not forget, we have both found out that it does lock, but that
isnt dvb-s2 because there is no video, so what is it for?

it doesnt mean anything as long as there is no picture.

On Sun, 6 Jun 2010 22:39:30 +0200
Niels Wagenaar <n.wagenaar@xs4all.nl> wrote:

> 2010/6/6 Lars Schotte <lars.schotte@schotteweb.de>:
> > how do you think i watch DVB-S?
> 
> I really don't know, I really don't care.
> 
> > now you are lying, and that for sure!
> 
> I do not. Please, read my information carefully. You seem to miss
> something.
> 
> > because mplayer has still this tunig issue, because he doesnt know
> > that coderate shit, and even so, i tried it w/ szap-s2 -r option
> > and tried to play it and only sound came out, so ... maybe you
> > should check it before writing again.
> >
> 
> I've never tried mplayer in combination with szap-s2. Like I told you
> before, I use VDR in combination with Xine.
> 
> > VLC and these ... players will do the same ... there is nothing
> > better than mplayer out there. mplayer is the best!!
> >
> 
> 
> 
> > i know, that DVB-T on HVR4000 is supported by linux, because yes it
> > works to me, but it doesnt find any programmes, so i would suggest
> > you try it out by yourself before writing again. like I wrote to
> > the first post - it works but is not usable (maybe internal noise
> > too high).
> >
> > analog TV works, and FM i didnt check.
> >
> 
> To proof to you (and the rest of this world) I'm not lying or
> whatever, here's my attempt with scan-s2 and szap-s2:
> 
> - I made an file called hd_astra with the following contents:
> 
> S 11361000 H 22000000 2/3
> 
> - Then I scanned with scan-s2:
> 
> ./scan-s2 -o zap ./hd_astra > ~/channels.conf
> 
> - Which gave me the following information:
> 
> Das Erste HD:11361:h:0:22000:6010:6020:11100:6
> ZDF HD:11361:h:0:22000:6110:6120:11110:6
> arte HD:11361:h:0:22000:6210:6221:11120:6
> 
> - Then I used szap-s2
> 
> ./szap-s2 -c ~/channels.conf -S 1 -M 5 -C 23 -n 2
> 
> - Which gave me the following output:
> 
> root@ubuntu:/usr/local/src/szap-s2# ./szap-s2 -c ~/channels.conf -S 1
> -M 5 -C 23 -n 2
> reading channels from file '/home/htpc/channels.conf'
> zapping to 2 'ZDF HD':
> delivery DVB-S2, modulation 8PSK
> sat 0, frequency 11361 MHz H, symbolrate 22000000, coderate 2/3,
> rolloff 0.35 vpid 0x17de, apid 0x17e8, sid 0x2b66
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal 05aa | snr 002e | ber 00000000 | unc fffffffe |
> status 1b | signal 05aa | snr 002c | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK status 1b | signal 05aa | snr 002d | ber 00516155 | unc
> fffffffe | FE_HAS_LOCK status 1b | signal 05aa | snr 002d | ber
> 00145855 | unc fffffffe | FE_HAS_LOCK status 1b | signal 05aa | snr
> 002c | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1b | signal
> 05aa | snr 002c | ber 00000000 | unc fffffffe | FE_HAS_LOCK
> 
> It locks. So mplayer should make it work. I can't test this since I
> don't have mplayer installed. But I think that some apologies are in
> order, since the issue is not with your hardware or szap-s2.
> 
> > On Sun, 6 Jun 2010 21:45:45 +0200
> > Niels Wagenaar <n.wagenaar@xs4all.nl> wrote:
> >
> >> Me? Lying? Before even telling me that I'm paid by Hauppauge,
> >> please be sure to read my post. I wrote that it works like a charm
> >> in combination with VDR (Google it). I've never used szap-s2 since
> >> I use VDR for my TV playback.
> >>
> >> By my better judgement I'm going to give you an other option. If
> >> you want to watch some TV without many options to configure (just
> >> install, scan and watch through VLC, mplayer, xbmc or whatever),
> >> you might want to check TV Headend
> >> (http://www.lonelycoder.com/hts/tvheadend_overview.html). It works
> >> like a charm with my NOVA-HD-S2.
> >>
> >> Oh and for your information. The DVB-T and DVB-S[2] of the device
> >> can't be used at the same time. It's not a driver issue, it's a
> >> hardware issue. In Windows you aren't able to do the same.
> >>
> >> The card (if it's the HVR-4000 or the NOVA-HD-S2) works perfectly
> >> under Linux. I even got it working with Kaffeine.
> >>
> >> 2010/6/6 Lars Schotte <lars.schotte@schotteweb.de>:
> >> > OK,
> >> > i am using w_scan, it scanned and found DVB-S2 channels but
> >> > szap-s2 doesnt tune in and there is no data, exactly like i
> >> > said, so either you are lying and you have none of this things
> >> > running or you were paid by huappauge to say this.
> >> >
> >> > i am using fedora 13 and HVR4000 and only DVB-S works. mplayer
> >> > has the same problem and again - I have no diseq switch
> >> > installed.
> >> >
> >>
> >
> 

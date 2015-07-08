Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35885 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbbGHHwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 03:52:10 -0400
Received: by igrv9 with SMTP id v9so194233878igr.1
        for <linux-media@vger.kernel.org>; Wed, 08 Jul 2015 00:52:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150708093330.4e06d388@dibcom294.coe.adi.dibcom.com>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
	<20150705184449.0017f114@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
	<20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
	<alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
	<20150707182541.0960177f@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071845250.72900@nic-i.leissner.se>
	<20150708093330.4e06d388@dibcom294.coe.adi.dibcom.com>
Date: Wed, 8 Jul 2015 09:52:09 +0200
Message-ID: <CAAZRmGw6amOSBiABpVspD5rDLme_uN4au0jDx4Jt-crOQk3npQ@mail.gmail.com>
Subject: Re: PCTV Triplestick and Raspberry Pi B+
From: Olli Salonen <olli.salonen@iki.fi>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Peter Fassberg <pf@leissner.se>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick has suggested many things here worth trying. In addition, you
can load the modules with more debugging enabled:

unload the modules first
modprobe si2168 dyndbg==pmf
modprobe si2157 dyndbg==pmf
modprobe em28xx debug=1

If you are willing to try, TechnoTrend CT2-4400 has the same si2168
and si2157 chips, but instead of the EM28xx it uses another USB
bridge. There are at least a few reports of people having a working
CT2-4400 with RPi2 here:
http://openelec.tv/forum/71-pvr-live-tv/72071-experimental-support-for-tt-ct2-4400-dvb-t2-c?start=30

Furthermore, kernel 3.16 was the first one to support the TripleStick
and the Si2168/si2157 chips. The drivers for those SiLabs devices have
improved quite significantly since that. Also, be extra careful with
the firmwares - I remember there was something different in the way
kernel 3.16 handled the Si2168 firmware compared to anything newer
than that. If you could try to upgrade the intel devices to 3.17 at
least (or with the latest media-build), download the firmware from
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/
and place it in /lib/firmware and then redo your test, it would be
helpful.

Cheers,
-olli


On 8 July 2015 at 09:33, Patrick Boettcher <patrick.boettcher@posteo.de> wrote:
> On Tue, 7 Jul 2015 18:51:16 +0200 (SST) Peter Fassberg <pf@leissner.se>
> wrote:
>
>> On Tue, 7 Jul 2015, Patrick Boettcher wrote:
>>
>> > Might be the RF frequency that is truncated on 32bit platforms
>> > somewhere. That could explain that there is no crash but simply not
>> > tuning.
>>
>> This is the current status:
>>
>> ARM 32-bit, kernel 4.0.6, updated media_tree: Works with DVB-T, no lock on DVB-T2.
>>
>> Intel 32-bit, kernel 3.16.0, standard media_tree: Locks, but no PSIs detected.
>>
>> Intel 64-bit, kernel 3.16.0, standard media_tree: Works like a charm.
>>
>>
>> So I don't think that en RF freq is truncated.
>
> Yes, it was an assumption - not a right one as it turned out. I didn't
> find any obvious 32/64-problem in the si*-drivers you are using.
>
> I'm too afraid to look into the em*-drivers and I doubt that there is
> any obvious 32/64-bit-problem.
>
> If I were you, I would try to compare the usb-traffic (using
> usbmon with wireshark) between a working tune on one frequency with one
> standard on each of the 3 scenarios (maybe starting with the intel 32
> and 64 platform).
>
> For example
>
> on each platform:
>
> 1) start wireshark-capture on the right USB-port,
> 2) plug the device,
> 3) tune (tzap) a valid DVB-T frequency
> 4) stop capturing
>
> Then compare the traffic log. Most outgoing data should be
> identical. Incoming data (except monitoring values and TS) should be
> equal as well.
>
> If you see differences in data-buffer-sizes or during the
> firmware-download-phase or anywhere else, we can try to find the code
> which corresponds and place debug messages. You are lucky, your drivers
> are using embedded firmwares which simplifies the communication between
> the driver and the device.
>
> regards,
> --
> Patrick.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

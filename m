Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2EDNtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 09:49:50 -0400
Received: by were53 with SMTP id e53so1761011wer.19
        for <linux-media@vger.kernel.org>; Fri, 04 May 2012 06:49:49 -0700 (PDT)
Message-ID: <4FA3DE7A.1080709@gmail.com>
Date: Fri, 04 May 2012 15:49:46 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com> <4FA249DE.7000702@gmail.com> <4FA33084.7050204@gmail.com>
In-Reply-To: <4FA33084.7050204@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi poma,
thanks for the very interesting links.

Il 04/05/2012 03:27, poma ha scritto:
> On 05/03/2012 11:03 AM, Gianluca Gennari wrote:
>> Hi poma,
>> I have a 0BDA:2838 (Easycap EZTV646) and a 0BDA:2832 (no name 20x20mm
>> mini DVB-T stick) and both are based on the E4000 tuner, which is not
>> supported in the kernel at the moment.
>> I have no idea if there are sticks with the same USB PID and the fc0012
>> tuner.
> 
> OK, second one - no name device is "Realtek RTL2832U reference design"**.
> 
> First one:
> Once upon a time there was a "EasyCAP"�
> "After while crocodile!"
> �and "EzCAP" was born.
> http://szforwardvideo.en.alibaba.com/aboutus.html
> Obviously Easycap EZTV646 != EzCAP EzTV646
> http://www.reddit.com/r/RTLSDR/comments/s6ddo/rtlsdr_compatibility_list_v2_work_in_progress/
> ezcap EzTV646	0BDA:2838	RTL2832U/FC0012		Some revisions may have the E4000*
> http://i.imgur.com/mFD1X.jpg
> (Generic)	0BDa:2838	RTL2832U/E4000*
> �
> And, in addition:
> http://sdr.osmocom.org/trac/wiki/rtl-sdr
> 0x0bda	0x2832	all of them	Generic RTL2832U (e.g. hama nano)**
> 0x0bda	0x2838	E4000	ezcap USB 2.0 DVB-T/DAB/FM dongle
> �
> Maybe?
> https://sites.google.com/site/myrtlsdr/

That's it. Opening the device enclosure, I can read this on the PCB:
"EzTV668 1.0"
and it looks identical to the picture posted there.

> "EzCap EZTV646 has got RTL2832U/FC0012. However rtl-sdr must be tweaked
> to force FC0012 tuner because it has the same PID as EZTV668 (PID:
> 0x2838) so running it whithout a tweak will select Elonics E4000 tuner.
> Works, not so good at filtering."
> �
> Conclusion:
> At least two devices share same vid/pid with different tuners - fc0012
> vs e4000.
> How to resolve this from a drivers perspective in a proper way?

This is not a big problem: the rtl2832 driver should read the tuner type
from an internal register and load the proper module (or exit with an
error message if the tuner is unsupported).

> Beside,
> there is GPL'ed 'e4k' tuner source code aka 'e4000 improved'*** (Elonics
> E4000)
> by Harald Welte
> http://cgit.osmocom.org/cgit/osmo-sdr/tree/firmware/src/tuner_e4k.c
> http://sdr.osmocom.org/trac/
> http://sdr.osmocom.org/trac/wiki/rtl-sdr
> http://wiki.spench.net/wiki/RTL2832U***

Very nice. So we should ask Harald Welte if he is willing to have his
driver merged in the kernel.

> regards,
> poma
> 

Regards,
Gianluca

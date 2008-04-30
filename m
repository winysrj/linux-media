Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JrH8g-0007eX-MD
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 20:34:47 +0200
Received: by yw-out-2324.google.com with SMTP id 9so370285ywe.41
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 11:34:37 -0700 (PDT)
Message-ID: <37219a840804301134q68a86301y2373329d2fef5a2f@mail.gmail.com>
Date: Wed, 30 Apr 2008 14:34:36 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Eric Cronin" <ecronin@gizmolabs.org>
In-Reply-To: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 failing to detect any QAM256 channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/4/30 Eric Cronin <ecronin@gizmolabs.org>:
>  I have an HP Pavilion OEM'd HVR-1800 that I'm giving a shot at getting
> working (PVR-500 and HDHR are my production analog/digital inputs).
>
>  I'm running Mythbuntu 8.04 and have tried both with the bundled version of
> v4l-dvb modules and a hg copy from April 29, and both have the same problem:
>
>  The card is detected fine and /dev/dvb/* created.  When I run 'scan
> us-Cable-Standard-center-frequencies-QAM256' it detects nothing, even on
> frequencies which I know are QAM256 from the HDHR which is 12" of coax away
> from the HVR-1800.  Here is an example from the HDHR scan:
>
>  SCANNING: 759000000 (us-cable:118, us-irc:118)
>  LOCK: qam256 (ss=90 snq=52 seq=100)
>  PROGRAM: 1: 6.1 WPVI-HD
>  PROGRAM: 2: 10.1 WCAU-DT
>  PROGRAM: 3: 6.2 WPVI-SD
>  PROGRAM: 4: 6.3 WPVI-WX
>  PROGRAM: 5: 10.2 WX-PLUS
>
>  and from 'scan -v test-chan118' which has just 759000000 in it:
>
>  scanning test-chan118
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  >>> tune to: 759000000:QAM_256
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  WARNING: >>> tuning failed!!!
>  >>> tune to: 759000000:QAM_256 (tuning failed)
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  WARNING: >>> tuning failed!!!
>  ERROR: initial tuning failed
>  dumping lists (0 services)
>  Done.
>
>  I have checked the physical connections best I can.  Connecting the
> HVR-1800's coax to the PVR-500 sees the analog side of things fine, and the
> correct jack on the HVR-1800 is being used.
>
>  I'm not sure where to go from here debugging things, any suggestions or
> more data I can provide?  The modprobe-produced info from dmesg is at the
> end of this message.


Eric,

When you use the scan command to scan for QAM channels, you must
specify -a2, to signify that you are scanning digital cable.

Try that -- does that work?

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JrHSr-0000n8-Du
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 20:55:38 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K0500BA3J7QXK81@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 30 Apr 2008 14:55:02 -0400 (EDT)
Date: Wed, 30 Apr 2008 14:55:01 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
To: Eric Cronin <ecronin@gizmolabs.org>
Message-id: <4818C085.6080000@linuxtv.org>
MIME-version: 1.0
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

Eric Cronin wrote:
> Hello,
> 
> I have an HP Pavilion OEM'd HVR-1800 that I'm giving a shot at getting 
> working (PVR-500 and HDHR are my production analog/digital inputs).
> 
> I'm running Mythbuntu 8.04 and have tried both with the bundled version 
> of v4l-dvb modules and a hg copy from April 29, and both have the same 
> problem:
> 
> The card is detected fine and /dev/dvb/* created.  When I run 'scan 
> us-Cable-Standard-center-frequencies-QAM256' it detects nothing, even on 
> frequencies which I know are QAM256 from the HDHR which is 12" of coax 
> away from the HVR-1800.  Here is an example from the HDHR scan:
> 

<snip>

> [67185.229777] msp3400' 3-0044: MSP5431H-^8 found @ 0x88 (cx23885[0])
> [67185.229782] msp3400' 3-0044: MSP5431H-^8 supports radio, mode is 
> autodetect and autoselect

This looks odd, but it should effect your digital scanning. MSP5431 
attached itself to the place when the cx25840 driver should be 
attaching. This is break analog support for you.

I'll have to look into this.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

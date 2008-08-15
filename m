Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaakko.tuomainen@gmail.com>) id 1KTwD4-0000yr-66
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 12:07:07 +0200
Received: by wf-out-1314.google.com with SMTP id 27so844455wfd.17
	for <linux-dvb@linuxtv.org>; Fri, 15 Aug 2008 03:07:00 -0700 (PDT)
Message-ID: <9e849af80808150307y369adb9fuf6ce50a1ac65435f@mail.gmail.com>
Date: Fri, 15 Aug 2008 13:07:00 +0300
From: "jaakko tuomainen" <jaakko.tuomainen@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [UNKNOWN CARD]Activy dvb-t (TDHD1- tuner,
	datasheet available)
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

Hi,

I have two Activy DVB-T cards in my Fujitsu Siemens htpc, both have
the Alps TDHD1-204A
tuner, which is not yet supported. I contacted alps for tuner's
datasheet and they sent it to me for linux driver development. I can
send email with the datasheet and pictures of my
card if someone is intrested in adding the support for my card. I
would like to contribute too but I lack the programming skills needed.
According to the datasheet, my own card and
this post "http://www.linuxtv.org/pipermail/linux-dvb/2008-August/027735.html"
the main chips are SAA7146AH and TDA10046 so I think it's possible to
add support
because those chips already have drivers.

Jaakko Tuomainen


lspci tells us following

01:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
    Subsystem: Philips Semiconductors Device 5f60
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (3750ns min, 9500ns max)
    Interrupt: pin A routed to IRQ 15
    Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=512]


01:0b.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
    Subsystem: Philips Semiconductors Device 5f60
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (3750ns min, 9500ns max)
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at fddfc000 (32-bit, non-prefetchable) [size=512]

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

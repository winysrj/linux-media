Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56499 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZJ1EA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 00:00:56 -0400
Received: by bwz27 with SMTP id 27so495580bwz.21
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 21:01:00 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 27 Oct 2009 23:01:00 -0500
Message-ID: <1427a9600910272101k15ee3b3aka244fbe45ad463bc@mail.gmail.com>
Subject: Probelms to tune pci dvb-s card
From: Lenin Aguilar <lenin.aguilar@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

I spent the last 4 days reading mailing lists and testing stuff in my
Mythbuntu installation.
I have a x86 machine running the latest Mythbuntu version, attached a
DM1105 PCI DVB-S card.

I read other trails from people having different kind of problems to
tune or lock a freq on this card... I am having similar problems, I
try to tune to well known and tested frequesncies and S Rates, with
out luck

This is what I get tuninmg to a tested freq, there is an unencrypted
channel on this tp:
***************************************************************************************
master@Main:~/DVB$ dvbtune -f 12092000 -s 28888 -p H
Using DVB card "ST STV0299 DVB-S"
tuning DVB-S to L-Band:0, Pol:H Srate=28888000, 22kHz=off
ERROR setting tone
: Connection timed out
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL
polling....
polling....
polling....
polling....
***************************************************************************************

In a different terminal, I ran dvbsnoop to check parameters, and here
what I get:
***************************************************************************************
master@Main:~/DVB$ dvbsnoop -s feinfo
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
    Name: "ST STV0299 DVB-S"
    Frontend-type:       QPSK (DVB-S)
    Frequency (min):     950.000 MHz
    Frequency (max):     2150.000 MHz
    Frequency stepsiz:   0.125 MHz
    Frequency tolerance: 0.000 MHz
    Symbol rate (min):     1.000000 MSym/s
    Symbol rate (max):     45.000000 MSym/s
    Symbol rate tolerance: 500 ppm
    Notifier delay: 0 ms
    Frontend capabilities:
        auto inversion
        FEC 1/2
        FEC 2/3
        FEC 3/4
        FEC 5/6
        FEC 7/8
        FEC AUTO
        QPSK

Current parameters:
    Frequency:  1492.000 MHz
    Inversion:  ON
    Symbol rate:  37.334000 MSym/s
    FEC:  FEC 2/3
*********************************************************************


Looks like the frequency parameter set by dvbtune are not taken by the card.

I also tested with szap, with well known freq,SR, VPID, etc, with the
same result, nothing appears in /dev/dvb/adapter0/dvr0

Any ideas about what to test is highly appreacited....


Greetings from Ecuador...

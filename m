Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38143 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbELBAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 21:00:45 -0400
Received: by wicnf17 with SMTP id nf17so429856wic.1
        for <linux-media@vger.kernel.org>; Mon, 11 May 2015 18:00:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 May 2015 02:00:44 +0100
Message-ID: <CAOQWjw3w4XMW2UM7AgZ=-SZCZGcqdFC631Hh52P5+-U=HhPL=Q@mail.gmail.com>
Subject: HP MCE IR (Fintek, 1934:5168) not decoding RC6-6A-20
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just picked up an HP MCE receiver (Fintek, 1934:5168) to use with
a Sky+ HD remote control, which uses the RC6-6A-20 protocol. Testing
has been carried out on a stock Debian 3.17-1-amd64 kernel.

Plugging of the receiver triggers the loading of the mceusb module and
setting the IR protocol to RC-6 as expected, but no usable scancodes
are received.

Testing the same remote with another mceusb receiver I have, a Topseed
1784:0001, results in the correct decoding of the RC6-6A-20 signals.

As far as I can see, the setup of both receivers in mceusb.c is the
same, with both being configured as MCE_GEN2_TX_INV.

Is there anything I can do to get the HP receiver to correctly decode
the RC6-6A-20 signals, or is it simply not going to work with this
particular remote?

Enabling debugging does show that rc-core is receiving and attempting
to decode the signals from the remote:

[984699.846241] show_protocols: allowed - 0xfffff, enabled - 0x20000
[984711.403096] show_protocols: allowed - 0xfffff, enabled - 0x20000
[984711.403126] Normal protocol change requested
[984711.403128] Protocols changed to 0x4
[984904.869932] show_protocols: allowed - 0xfffff, enabled - 0x4
[984904.869958] Normal protocol change requested
[984904.869960] Protocols changed to 0x3e000
[984916.490389] show_protocols: allowed - 0xfffff, enabled - 0x3e000
[984921.506571] sample: (99250us space)
[984921.506574] sample: (02650us pulse)
[984921.506575] sample: (00950us space)
[984921.506575] sample: (00500us pulse)
[984921.506597] RC6 decode started at state 0 (99250us space)
[984921.506598] RC6 decode failed at state 0 (99250us space)
[984921.506601] RC6 decode started at state 0 (2650us pulse)
[984921.506602] RC6 decode started at state 1 (950us space)
[984921.506606] RC6 decode started at state 2 (500us pulse)
[984921.508568] sample: (00400us space)
[984921.508570] sample: (00450us pulse)
[984921.508570] sample: (00450us space)
[984921.508571] sample: (00500us pulse)
[984921.508580] RC6 decode started at state 3 (400us space)
[984921.508591] RC6 decode started at state 2 (0us space)
[984921.508592] RC6 decode started at state 2 (450us pulse)
[984921.508593] RC6 decode started at state 3 (450us space)
[984921.508594] RC6 decode started at state 2 (6us space)
[984921.508595] RC6 decode started at state 2 (500us pulse)
[984921.511551] sample: (00850us space)
[984921.511552] sample: (00450us pulse)
[984921.511553] sample: (00900us space)
[984921.511554] sample: (00950us pulse)
[984921.511561] RC6 decode started at state 3 (850us space)
[984921.511562] RC6 decode started at state 2 (406us space)
[984921.511574] RC6 decode started at state 3 (450us pulse)
[984921.511574] RC6 decode started at state 4 (6us pulse)
[984921.511575] RC6 decode started at state 4 (900us space)
[984921.511576] RC6 decode started at state 5 (950us pulse)
[984921.511577] RC6 decode started at state 6 (61us pulse)
[984921.512564] sample: (00400us space)
[984921.512565] sample: (00450us pulse)
[984921.512566] sample: (00450us space)
[984921.512566] sample: (00500us pulse)
[984921.512572] RC6 decode started at state 6 (400us space)
[984921.512574] RC6 decode started at state 7 (450us pulse)
[984921.512574] RC6 decode started at state 6 (6us pulse)
[984921.512575] RC6 decode started at state 6 (450us space)
[984921.512576] RC6 decode started at state 7 (500us pulse)
[984921.512577] RC6 decode started at state 6 (56us pulse)
[984921.514561] sample: (00400us space)
[984921.514562] sample: (00450us pulse)
[984921.514563] sample: (00450us space)
[984921.514563] sample: (00500us pulse)
[984921.514569] RC6 decode started at state 6 (400us space)
[984921.514571] RC6 decode started at state 7 (450us pulse)
[984921.514571] RC6 decode started at state 6 (6us pulse)
[984921.514572] RC6 decode started at state 6 (450us space)
[984921.514573] RC6 decode started at state 7 (500us pulse)
[984921.514573] RC6 decode started at state 6 (56us pulse)
[984921.517558] sample: (00400us space)
[984921.517560] sample: (00850us pulse)
[984921.517560] sample: (00950us space)
[984921.517561] sample: (00850us pulse)
[984921.517569] RC6 decode started at state 6 (400us space)
[984921.517581] RC6 decode started at state 7 (850us pulse)
[984921.517582] RC6 decode started at state 6 (406us pulse)
[984921.517583] RC6 decode started at state 7 (950us space)
[984921.517583] RC6 decode started at state 6 (506us space)
[984921.517584] RC6 decode started at state 7 (850us pulse)
[984921.517585] RC6 decode started at state 6 (406us pulse)
[984921.519542] sample: (00500us space)
[984921.519543] sample: (00450us pulse)
[984921.519544] sample: (00400us space)
[984921.519544] sample: (00500us pulse)
[984921.519551] RC6 decode started at state 7 (500us space)
[984921.519552] RC6 decode started at state 6 (56us space)
[984921.519564] RC6 decode started at state 6 (450us pulse)
[984921.519564] RC6 decode started at state 7 (400us space)
[984921.519565] RC6 decode started at state 6 (0us space)
[984921.519566] RC6 decode started at state 6 (500us pulse)
[984921.521553] sample: (00850us space)
[984921.521555] sample: (00500us pulse)
[984921.521555] sample: (00400us space)
[984921.521556] sample: (00500us pulse)
[984921.521562] RC6 decode started at state 7 (850us space)
[984921.521562] RC6 decode started at state 6 (406us space)
[984921.521564] RC6 decode started at state 7 (500us pulse)
[984921.521564] RC6 decode started at state 6 (56us pulse)
[984921.521565] RC6 decode started at state 6 (400us space)
[984921.521565] RC6 decode started at state 7 (500us pulse)
[984921.521566] RC6 decode started at state 6 (56us pulse)
[984921.524551] sample: (00400us space)
[984921.524553] sample: (00900us pulse)
[984921.524553] sample: (00900us space)
[984921.524554] sample: (00900us pulse)
[984921.524562] RC6 decode started at state 6 (400us space)
[984921.524574] RC6 decode started at state 7 (900us pulse)
[984921.524575] RC6 decode started at state 6 (456us pulse)
[984921.524576] RC6 decode started at state 7 (900us space)
[984921.524577] RC6 decode started at state 6 (456us space)
[984921.524577] RC6 decode started at state 7 (900us pulse)
[984921.524578] RC6 decode started at state 6 (456us pulse)
[984921.527564] sample: (00400us space)
[984921.527566] sample: (00450us pulse)
[984921.527567] sample: (00450us space)
[984921.527567] sample: (00450us pulse)
[984921.527575] RC6 decode started at state 7 (400us space)
[984921.527586] RC6 decode started at state 6 (0us space)
[984921.527588] RC6 decode started at state 6 (450us pulse)
[984921.527589] RC6 decode started at state 7 (450us space)
[984921.527589] RC6 decode started at state 6 (6us space)
[984921.527590] RC6 decode started at state 6 (450us pulse)
[984921.534541] sample: (00900us space)
[984921.534543] sample: (00500us pulse)
[984921.534544] sample: (00400us space)
[984921.534544] sample: (00450us pulse)
[984921.534552] RC6 decode started at state 7 (900us space)
[984921.534553] RC6 decode started at state 6 (456us space)
[984921.534565] RC6 decode started at state 7 (500us pulse)
[984921.534565] RC6 decode started at state 6 (56us pulse)
[984921.534566] RC6 decode started at state 6 (400us space)
[984921.534567] RC6 decode started at state 7 (450us pulse)
[984921.534568] RC6 decode started at state 6 (6us pulse)
[984921.627466] sample: (00000us space)


This output is for a single keypress on the remote. I see a single
failure message - does this help shed any light on the problem? Is
there any further debugging I can do?


Cheers,
Nick

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0FFN2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jun 2010 09:28:11 -0400
Received: by bwz11 with SMTP id 11so734417bwz.19
        for <linux-media@vger.kernel.org>; Sun, 06 Jun 2010 06:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100606150554.55be1852@romy.gusto>
References: <20100606010311.6d98ef7b@romy.gusto>
	<20100606084301.GA3070@gmail.com>
	<20100606133946.76c3a6e0@romy.gusto>
	<20100606124925.GB3070@gmail.com>
	<20100606145154.60de422e@romy.gusto>
	<20100606125636.GC3070@gmail.com>
	<20100606150554.55be1852@romy.gusto>
Date: Sun, 6 Jun 2010 15:28:07 +0200
Message-ID: <AANLkTin1jaMbG0ULhQRZi3QWkd2oVXazJ4BTGh5rMYdM@mail.gmail.com>
Subject: Re: [linux-dvb] hvr4000 doesnt work w/ dvb-s2 nor DVB-T
From: Niels Wagenaar <n.wagenaar@xs4all.nl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No offence. But all these problems are complete FUD. I've been using a
HVR-4000 and a NOVA-HD-S2 since VDR 1.7.0 (which required multiproto)
and since I made the S2API-patch for VDR 1.7.0 (which I released in
October 2009). I've never experienced these issues in the past 1,5
years.

DiSEqC handling is no problem at all. I've set it up with DiSEqC 1.0
and 1.2 in combination with VDR. And I've never seen any lock problems
with DVB-S2 channels using QPSK or 8PSK modulation on Hotbird 13.0e,
Astra 19.2e, Astra 23.5e and Astra 28.2e.

If you need channellists (why even use something like szap, scan or
wscan if you can download it yourself), just go to Linowsat [1] or VDR
Settings [2]. And here's an example for a diseqc.conf which I've used
since the beginning:

# port 1 option a position a -> Astra 19.2e
# port 2 option a position b -> Hotbird 13.0e
# port 3 option b position a -> Astra 23.5e
# port 4 option b position b -> Astra 28.2e / Eurobird 28.5e
#
# port 1
S19.2E  11700 V  9750   t v W15 [E0 10 38 F0] W100 [E0 10 38 F0] W100
[E0 11 00] W100 A W15 t
S19.2E  99999 V 10600   t v W15 [E0 10 38 F1] W100 [E0 10 38 F1] W100
[E0 11 00] W100 A W15 T
S19.2E  11700 H  9750   t V W15 [E0 10 38 F2] W100 [E0 10 38 F2] W100
[E0 11 00] W100 A W15 t
S19.2E  99999 H 10600   t V W15 [E0 10 38 F3] W100 [E0 10 38 F3] W100
[E0 11 00] W100 A W15 T
# port 2
S13.0E  11700 V  9750   t v W15 [E0 10 38 F4] W100 [E0 10 38 F4] W100
[E0 11 00] W100 B W15 t
S13.0E  99999 V 10600   t v W15 [E0 10 38 F5] W100 [E0 10 38 F5] W100
[E0 11 00] W100 B W15 T
S13.0E  11700 H  9750   t V W15 [E0 10 38 F6] W100 [E0 10 38 F6] W100
[E0 11 00] W100 B W15 t
S13.0E  99999 H 10600   t V W15 [E0 10 38 F7] W100 [E0 10 38 F7] W100
[E0 11 00] W100 B W15 T
# port 3
S23.5E  11700 V  9750   t v W15 [E0 10 38 F8] W100 [E0 10 38 F8] W100
[E0 11 00] W100 A W15 t
S23.5E  99999 V 10600   t v W15 [E0 10 38 F9] W100 [E0 10 38 F9] W100
[E0 11 00] W100 A W15 T
S23.5E  11700 H  9750   t V W15 [E0 10 38 FA] W100 [E0 10 38 FA] W100
[E0 11 00] W100 A W15 t
S23.5E  99999 H 10600   t V W15 [E0 10 38 FB] W100 [E0 10 38 FB] W100
[E0 11 00] W100 A W15 T
# port 4
S28.2E  11700 V  9750   t v W15 [E0 10 38 FC] W100 [E0 10 38 FC] W100
[E0 11 00] W100 B W15 t
S28.2E  99999 V 10600   t v W15 [E0 10 38 FD] W100 [E0 10 38 FD] W100
[E0 11 00] W100 B W15 T
S28.2E  11700 H  9750   t V W15 [E0 10 38 FE] W100 [E0 10 38 FE] W100
[E0 11 00] W100 B W15 t
S28.2E  99999 H 10600   t V W15 [E0 10 38 FF] W100 [E0 10 38 FF] W100
[E0 11 00] W100 B W15 T
S28.5E  11700 V  9750   t v W15 [E0 10 38 FC] W100 [E0 10 38 FC] W100
[E0 11 00] W100 B W15 t
S28.5E  99999 V 10600   t v W15 [E0 10 38 FD] W100 [E0 10 38 FD] W100
[E0 11 00] W100 B W15 T
S28.5E  11700 H  9750   t V W15 [E0 10 38 FE] W100 [E0 10 38 FE] W100
[E0 11 00] W100 B W15 t
S28.5E  99999 H 10600   t V W15 [E0 10 38 FF] W100 [E0 10 38 FF] W100
[E0 11 00] W100 B W15 T


2010/6/6 Lars Schotte <lars.schotte@schotteweb.de>:
> I dont have a Diseq swich installed at the moment.
>
> On Sun, 6 Jun 2010 14:56:36 +0200
> Gregoire Favre <gregoire.favre@gmail.com> wrote:
>
>> On Sun, Jun 06, 2010 at 02:51:54PM +0200, Lars Schotte wrote:
>>
>> > ah. so i see you had some problems as well. thats better, because as
>> > long as i am not the only one maybe some time it will work.
>>
>> ??? It was the developpement process and Disecq wasn't working right
>> in the driver, which is now fixed, so the time I spent for this card
>> should be good for you.


-- 
Met vriendelijke groet/Regards,

Niels Wagenaar

-- Sent from my BlackBerry® smartphone

1) http://www.linowsat.de/settings/vdr.html or
2) http://www.vdr-settings.com/download/channels/

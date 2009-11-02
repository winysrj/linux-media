Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lo.gmane.org ([80.91.229.12])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1N534a-00042S-Dz
	for linux-dvb@linuxtv.org; Mon, 02 Nov 2009 21:00:17 +0100
Received: from list by lo.gmane.org with local (Exim 4.50) id 1N534V-0005Cf-6P
	for linux-dvb@linuxtv.org; Mon, 02 Nov 2009 21:00:11 +0100
Received: from 78-105-205-147.zone3.bethere.co.uk ([78.105.205.147])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 02 Nov 2009 21:00:11 +0100
Received: from topper.doggle by 78-105-205-147.zone3.bethere.co.uk with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 02 Nov 2009 21:00:11 +0100
To: linux-dvb@linuxtv.org
From: TD <topper.doggle@googlemail.com>
Date: Mon, 2 Nov 2009 19:52:28 +0000 (UTC)
Message-ID: <hcnd9s$c1f$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
	Nova-HD-S2
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi all.  I'm at the end of my tether here so hopefully someone can offer a
clue.  I'm building a MythTV box with a Happauage WinTV Nova-HD-S2 PCI card
which I'd like to use to receive Freesat via Astra (2D) here in the UK.  I've
built a DVB-T MythTV box in the past, so I'm not too green.

The card itself is recognized by my 2.6.30 kernel, and I've got the firmware
loading.
[  139.141728] i2c-adapter i2c-2: firmware: requesting dvb-fe-cx24116.fw
[  139.176026] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[  143.271646] cx24116_load_firmware: FW version 1.20.79.0
[  143.271653] cx24116_firmware_ondemand: Firmware upload complete

However, that's where the good bits end.  I tried a channel scan in Myth which
was mostly underwhelming, and I realised that it was mostly picking up
channels from Astra 2A and 2B, which are encrypted, and not what I want.

I then tried the (dvb)scan utility, as it operates at a lower level and lets
me see what's going on more.  I had output like:
$ scan -x 0 /usr/share/dvb/dvb-s/Astra-28.2E
scanning /usr/share/dvb/dvb-s/Astra-28.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
<***snip ***>
initial transponder 12629000 V 6111000 3
initial transponder 12692000 V 19532000 1
>>> tune to: 11720:h:0:29500
DVB-S IF freq is 1120000
WARNING: >>> tuning failed!!!
>>> tune to: 11720:h:0:29500 (tuning failed)
DVB-S IF freq is 1120000
WARNING: >>> tuning failed!!!
>>> tune to: 11740:v:0:27500
DVB-S IF freq is 1140000
0x0000 0x1776: pmt_pid 0x0000 BSkyB -- Bravo+1 (running, scrambled)
0x0000 0x1777: pmt_pid 0x0000 BSkyB -- LIVING2 (running, scrambled)
0x0000 0x177c: pmt_pid 0x0000 BSkyB -- Challenge+ (running, scrambled)
0x0000 0x177e: pmt_pid 0x0000 BSkyB -- Bravo+ (running, scrambled)
0x0000 0x1788: pmt_pid 0x0000 BSkyB -- Bravo~ (running, scrambled)
...

I'm not sure what "tuning failed" means, but I bet it has something to do with
my problem.  NB I can watch the few clear channels that it does pick up e.g.
Sky News, Luxe etc.

The setup is that this is a newly-built flat, with a double F-socket on the
wall.  I followed it down to the distribution panel in the basement, and it's
connected to a Delta MS 5024 N multiswitch.  From what I could make out, said
switch has four cables going in (vertical 0khz, horiz 0khz, vertical 22khz,
horiz 0khz), and lots of cables going to the flats.

I don't know much about it, but it seems to me that if the switch is designed
to have Sky digiboxes plugged into it, that it is designed to appear as an LNB
to equipment, therefore I don't need to mess around with DiSEqC or anything
similar?  No magic going on?

Anyway, I'd really appreciate some guidance here as I just don't know what to
do, or how I can debug this further.

(I'm going to borrow a Sky box from a friend tonight just to verify the uplink
to the flat is working properly.)

-- 
TD


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

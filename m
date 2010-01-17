Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp30.wxs.nl ([195.121.247.32]:39933 "EHLO psmtp30.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0AQUe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 15:34:59 -0500
Received: from verminac.speed.planet.nl
 (ip503cf398.speed.planet.nl [80.60.243.152])
 by psmtp30.wxs.nl (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14
 2006)) with ESMTP id <0KWE0043BRUAJK@psmtp30.wxs.nl> for
 linux-media@vger.kernel.org; Sun, 17 Jan 2010 21:34:58 +0100 (MET)
Received: from mail.vermin.nl (unknown [192.168.1.5])
	by verminac.speed.planet.nl (Postfix) with ESMTP id F24092909FF	for
 <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 21:34:57 +0100 (CET)
Date: Sun, 17 Jan 2010 21:34:57 +0100 (CET)
From: Sander Vermin <sander@vermin.nl>
Subject: Status of TT C1501
To: linux-media@vger.kernel.org
Reply-to: sander@vermin.nl
Message-id: <44303.83.86.78.248.1263760497.squirrel@mail.vermin.nl>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I bought a TechnoTrend C-1501 witch has:
Philips tda827x
Philips tda10023 Demodulator
Philips saa7146ah PCI-Bridge

I have got the channel scan working, but I cant get it to tune to a channel.

When I tune to a channel this happens:
czap -c ~/.czap/czap-final.txt "Nederland 1"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
 84 Nederland 1:388000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:88:89:8004
ERROR: cannot parse service data

When I try to scan channels in a mux I get:
scandvb -c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
dumping lists (0 services)
Done.

According to linuxtv wiki it should just work fine:
http://linuxtv.org/wiki/index.php/DVB-C_PCI_Cards

This all is at a fedora 12 x86_64 machine, I have already tried the latest
v4l-dvb drivers. (my cable company is Ziggo here in the Netherlands
(former Casema region))

I hope someone can help me out.

Best regards,

Sander Vermin


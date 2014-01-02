Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:62065 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaABBB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 20:01:29 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so5950447eaj.21
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 17:01:28 -0800 (PST)
Received: from [10.200.14.23] (31-151-102-59.dynamic.upc.nl. [31.151.102.59])
        by mx.google.com with ESMTPSA id o1sm131508946eea.10.2014.01.01.17.01.27
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 01 Jan 2014 17:01:27 -0800 (PST)
From: wessel@louwris.nl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: current program/show information tuned in with [c]zap
Message-Id: <1B3DBB99-AB13-408A-BC1C-526A2A42AD7B@louwris.nl>
Date: Thu, 2 Jan 2014 02:01:27 +0100
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I’m tuning to a DVB-C channel with czap (czap -r "channelname”) and then I’m creating screenshots from this channel with mplayer (mplayer /dev/dvb/adapter0/dvr0 -vo png -frames 1). This works.

I also need the current program/show title on this channel in text (or picture) for this screenshot.

I found a way with tv_grab_dvb (tv_grab_dvb -m) and parsing the xml. But that takes 10 seconds for the EPG (processes all channels) where I only need the title of the current program on the channel tuned in with czap.
Is there an easier/faster way possible?

I’m trying things with dvbsnoop  but I’m getting lost in the PID’s/multiplex  etc
(For example:
	scan  /usr/share/dvb/dvb-c/nl-UPC
gives among others:
	0x0817 0x47b9: pmt_pid 0x0780 UPC NL -- VRT 1 (running)
But
	dvbsnoop -s sec -ph 3 -n 10 -crc  0x0780
gives nothing
and
	dvbsnoop -s sec 0x0780 -b -n 200 > /tmp/VRT1.bin
	./tv_grab_dvb -i /tmp/x.bin -f /tmp/VRT1.xml
gives only the channel listing)

Maybe someone here can give me a clue?

Thanks. Wessel
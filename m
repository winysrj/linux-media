Return-path: <linux-media-owner@vger.kernel.org>
Received: from 83-103-0-23.ip.fastwebnet.it ([83.103.0.23]:37639 "EHLO
	motoko.logossrl.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbaHYT2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 15:28:19 -0400
Received: from host62-132-dynamic.11-87-r.retail.telecomitalia.it ([87.11.132.62] helo=aika.discordia.loc)
	by motoko.logossrl.com with esmtpsa (UNKNOWN:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <l.marcantonio@logossrl.com>)
	id 1XLzVa-0005hP-Vk
	for linux-media@vger.kernel.org; Mon, 25 Aug 2014 21:00:51 +0200
Date: Mon, 25 Aug 2014 21:01:11 +0200
From: Lorenzo Marcantonio <l.marcantonio@logossrl.com>
To: linux-media@vger.kernel.org
Subject: strange empia device
Message-ID: <20140825190109.GB3372@aika.discordia.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just bought a roxio video capture dongle. Read around that it was an
easycap clone (supported, then); it seems it's not so anymore :(

It identifies as 1b80:e31d Roxio Video Capture USB

(it also uses audio class for audio)

Now comes the funny thing. Inside there is the usual E2P memory,
a regulator or two and an empia marked EM2980 (*not* em2890!); some
passive and nothing else.

Digging around in the driver cab (emBDA.inf) shows that it seems an
em28285 driver rebranded by roxio... it installs emBDAA.sys and
emOEMA.sys (pretty big: about 1.5MB combined!); also a 16KB merlinFW.rom
(presumably a firmware for the em chip?  I tought they were fixed
function); also the usual directshow .ax filter and some exe in
autorun (emmona.exe: firmware/setup loader?).

Looking in the em28xx gave me the idea that that thing is not
supported (at least in my current 3.6.6)... however the empia sites says
(here http://www.empiatech.com/wp/video-grabber-em282xx/) 28284 should
be linux supported. Nothing said about 28285. And the chip is marked
2980?! by the way, forcing the driver to load I get this:

[ 3439.787701] em28xx: New device  Roxio Video Capture USB @ 480 Mbps (1b80:e31d, interface 0, class 0)
[ 3439.787704] em28xx: Video interface 0 found
[ 3439.787705] em28xx: DVB interface 0 found
[ 3439.787866] em28xx #0: em28xx chip ID = 146

Is there any hope to make it work (even on git kernel there is nothing
for chip id 146...)?

-- 
Lorenzo Marcantonio
Logos Srl

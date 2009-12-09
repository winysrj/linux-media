Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23206.mail.ird.yahoo.com ([217.146.189.61]:25325 "HELO
	web23206.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751050AbZLIUWA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 15:22:00 -0500
Message-ID: <211341.40316.qm@web23206.mail.ird.yahoo.com>
Date: Wed, 9 Dec 2009 20:15:24 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: no locking on dvb-s2 22000 2/3 8PSK transponder on Astra 19.2E with tt s2-3200
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

no matter if I use Igors or Manus driver, there's no lock on 11303 h 22000 2/3 8psk. Other users at vdr-portal report same problem.

The strange thing is that all other transponders that use 22000 2/3 8psk do work but this transponder doesn't. It worked fine until december 3rd when uplink moved to Vienna. I think they changed a parameter like rolloff or inversion and the dvb-s2 part of stb6100 is buggy.

regards

Newspaperman

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

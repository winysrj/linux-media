Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lncsa.com ([212.99.8.243]:40834 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751392AbZDUHzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 03:55:06 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id F2F243071F60
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 09:48:04 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YLyVTyx+TeRA for <linux-media@vger.kernel.org>;
	Tue, 21 Apr 2009 09:48:04 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id CF3A43071F5F
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 09:48:04 +0200 (CEST)
Received: from galba.apartia.fr (galba.apartia.fr [10.0.3.119])
	by zenon.apartia.fr (Postfix) with ESMTP id 8050E5B940335
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 09:48:01 +0200 (CEST)
Date: Tue, 21 Apr 2009 09:48:01 +0200
From: Louis-David Mitterrand <vindex+lists-linux-media@apartia.org>
To: linux-media@vger.kernel.org
Subject: Nova-TD usb dual tuner issue
Message-ID: <20090421074801.GA18549@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

When I connect my Nova-TD dual tuner usb stick to my debian/sid box with
2.6.29.1 kernel I can only use the second tuner (mplayer
dvb://2@<tvchannel>). When trying to use the first one (dvb://1@...)
tuning is extremely bad and an image barely appears with many errors.

I tried switching the antennas to no avail, the problem persists.

Is this a know problem, or do I just have a bad stick ?

Thanks,

PS: here is the syslog output when connecting the stick:

	usb 2-2: new high speed USB device using ehci_hcd and address 3
	Apr 19 15:33:50 delos kernel: usb 2-2: configuration #1 chosen from 1 choice
	Apr 19 15:33:50 delos kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in cold state, will try to load a firmware
	Apr 19 15:33:50 delos kernel: usb 2-2: firmware: requesting dvb-usb-dib0700-1.20.fw
	Apr 19 15:33:50 delos kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
	Apr 19 15:33:50 delos kernel: dib0700: firmware started successfully.
	Apr 19 15:33:51 delos kernel: dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in warm state.
	Apr 19 15:33:51 delos kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
	Apr 19 15:33:51 delos kernel: DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
	Apr 19 15:33:51 delos kernel: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
	Apr 19 15:33:51 delos kernel: DiB0070: successfully identified
	Apr 19 15:33:51 delos kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
	Apr 19 15:33:51 delos kernel: DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
	Apr 19 15:33:51 delos kernel: DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
	Apr 19 15:33:52 delos kernel: DiB0070: successfully identified


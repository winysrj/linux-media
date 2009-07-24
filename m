Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos03.frii.com ([216.17.128.163]:49849 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724AbZGXCdQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 22:33:16 -0400
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by mail.frii.com (FRII) with ESMTP id A4B2D6A07B
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 20:33:15 -0600 (MDT)
Date: Thu, 23 Jul 2009 20:33:15 -0600
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: TBS 8920 still fails to initialize - cx24116_readreg error
Message-ID: <20090724023315.GA96337@io.frii.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings:

Using current current v4l-dvb drivers, I get the following in the
dmesg:

cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
cx88[1]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
cx24116_readreg: reg=0xff (error=-6)
cx24116_readreg: reg=0xfe (error=-6)
Invalid probe, probably not a CX24116 device
cx88[1]/2: frontend initialization failed
cx88[1]/2: dvb_register failed (err = -22)
cx88[1]/2: cx8802 probe failed, err = -22

Does this mean that one of the chips on this card is different than
expected? How can I gather useful information about this?

-- Mark


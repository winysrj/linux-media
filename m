Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:54767 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbZLGL1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 06:27:19 -0500
Received: from pub6.ifh.de (pub6.ifh.de [141.34.15.118])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id nB7BRLxR019162
	for <linux-media@vger.kernel.org>; Mon, 7 Dec 2009 12:27:21 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by pub6.ifh.de (Postfix) with ESMTP id CFB21300124
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2009 12:27:20 +0100 (CET)
Date: Mon, 7 Dec 2009 12:27:20 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DiB0700: streaming buffer size changed
Message-ID: <alpine.LRH.2.00.0912071224350.13793@pub6.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello DiB0700-users,

Soon Mauro will pull in some changes on the dib0700-usb bridge which will 
change the streaming-buffer-size by default.

According to our tests this should not create any problems and 
unfortunately it won't fix anything except some timeouts on low-bitrate 
services/sections when HW-PID-filtering is enabled.

If anyone of you DiB0700-users experiences any odd behaviour after the 
patch has been applied to v4l-dvb, please report immediatly.

thanks,

--

Patrick
http://www.kernellabs.com/

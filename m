Return-path: <linux-media-owner@vger.kernel.org>
Received: from bruce.bmat.com ([176.9.54.181]:49832 "EHLO bruce.bmat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbbAHPMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 10:12:35 -0500
Received: from localhost (localhost [127.0.0.1])
	by bruce.bmat.com (Postfix) with ESMTP id BD9A7C14328
	for <linux-media@vger.kernel.org>; Thu,  8 Jan 2015 16:12:34 +0100 (CET)
Received: from bruce.bmat.com ([127.0.0.1])
	by localhost (bruce.bmat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id da70kofj0cEk for <linux-media@vger.kernel.org>;
	Thu,  8 Jan 2015 16:12:33 +0100 (CET)
Received: from jbrines.bmat.office (164.red-80-28-250.adsl.static.ccgg.telefonica.net [80.28.250.164])
	(Authenticated sender: jbrines@bmat.es)
	by bruce.bmat.com (Postfix) with ESMTPSA id E55AEC14325
	for <linux-media@vger.kernel.org>; Thu,  8 Jan 2015 16:12:32 +0100 (CET)
From: Javier Brines Garcia <jbrines@bmat.es>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: HDMI recording signals
Message-Id: <60337A00-448B-43E0-A002-1E3E6EA9CF14@bmat.es>
Date: Thu, 8 Jan 2015 16:12:31 +0100
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry I'm newbie into this. Can anyone help me to record HDMI signal with the DeckLink Mini Recorder via command line? In the SDK there's a program called Capture and I've also tried with a GIT repo from the bmdcapture soft that comes with other cards.

When I type this command

bmdcapture -m 13 -F nut -A 2 -V 3 -f test.raw

I get first time a file with the typical color bars. And second time and so, it generates 0 size files. Same problem testing different inputs with different video formats...

Now I've got connected a Raspberry P (B Model), with a Game of Thrones chapter looped, and I can't get any signal. If I install the GUI I can't see anything with the visual soft. I've tried different DeckLink MiniRecorder cards (in case card was broken/not working good), and spoke to the technician support from Blackmagic and it seems that this card is difficult to make it work with Debian.

I need to make it work with the command-line. Can somebody help me?

Many thanks in advance, 

Javier
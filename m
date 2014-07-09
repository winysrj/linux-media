Return-path: <linux-media-owner@vger.kernel.org>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:59385 "EHLO
	burgundy.papayaltd.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753145AbaGINWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 09:22:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by burgundy.papayaltd.net (Postfix) with ESMTP id 372741000AE
	for <linux-media@vger.kernel.org>; Wed,  9 Jul 2014 14:14:25 +0100 (BST)
Received: from burgundy.papayaltd.net ([127.0.0.1])
	by localhost (burgundy.fair.dinkum.org.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QrDW3bgXtBri for <linux-media@vger.kernel.org>;
	Wed,  9 Jul 2014 14:14:23 +0100 (BST)
Received: from 145.129.187.81.in-addr.arpa (145.129.187.81.in-addr.arpa [81.187.129.145])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: andre)
	by burgundy.papayaltd.net (Postfix) with ESMTPSA id BDD361000AD
	for <linux-media@vger.kernel.org>; Wed,  9 Jul 2014 14:14:22 +0100 (BST)
From: Andre Newman <linux-media@dinkum.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: PCTV T292e whole DVBT2 mux/Ultra HD performance question
Message-Id: <35906397-E8F4-4229-966F-7ED578441C10@dinkum.org.uk>
Date: Wed, 9 Jul 2014 14:14:21 +0100
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I’m using a T290e for whole mux DVBT2 capture, using this to record the current BBC World Cup Ultra HD tests, works well. :-)

It seems impossible to buy more T290e’s, everyone want to sell me a T292e, I understand there is a driver now, thanks Antti. I read on Antti’s blog that there is a limit on raw TS performance with the T292, that it didn’t work well with QAM256 because of this...

I am wondering if this is a hardware limit, or a performance problem that may have been resolved now the driver is a little tiny bit more mature?

I am very happy to get a T292e and make some tests, help debug if there is a hope that it can handle 40Mbps in hardware.If there is a hardware limit I’d rather not be stuck with a limited tuner!

The mux I need to record is QAM256 at ~40Mbps and the UHD video is ~36Mbps of this.

Otherwise what other DVBT2 tuners are there that can capture a raw QAM256 mux at 40Mbps?

Andre
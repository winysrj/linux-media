Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55915 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaCXQww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 12:52:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WS87D-0000hl-Ox
	for linux-media@vger.kernel.org; Mon, 24 Mar 2014 17:52:47 +0100
Received: from dslb-188-106-243-224.pools.arcor-ip.net ([188.106.243.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 17:52:47 +0100
Received: from Bassai_Dai by dslb-188-106-243-224.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 17:52:47 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: why frameformat instead pixelformat?
Date: Mon, 24 Mar 2014 16:52:22 +0000 (UTC)
Message-ID: <loom.20140324T174253-993@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

while reading into the media-api issue I found out that for configuring the 
entity pads a frameformat is used.

For that I found the negotiation rfc of that topic, but I don't really get 
the relevance of a frameformat.

http://www.spinics.net/lists/linux-media/msg10006.html

Can anyone explain why the media-api uses the frameformat instead of the 
pixelformat and what the main differences are?

Thanks in advance.

Best regards,
Tom


Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52305 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3HUMlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 08:41:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VC7if-0000QJ-RD
	for linux-media@vger.kernel.org; Wed, 21 Aug 2013 14:41:01 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 14:41:01 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 14:41:01 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: media-ctl: line 1: syntax error: "(" unexpected
Date: Wed, 21 Aug 2013 12:40:42 +0000 (UTC)
Message-ID: <loom.20130821T143312-331@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I got the media-ctl tool from http://git.ideasonboard.org/git/media-ctl.git
and compiled and build it successfully. But when try to run it I get this error:

sudo ./media-ctl -r -l "ov3640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":1->"OMAP3 ISP CCDC output":0[1]

./media-ctl: line 1: syntax error: "(" unexpected

Does anyone know how I can solve that problem?

Best Regards, Tom


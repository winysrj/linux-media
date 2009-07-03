Return-path: <linux-media-owner@vger.kernel.org>
Received: from acoma.photonsoftware.net ([65.254.60.10]:43514 "EHLO
	acoma.photonsoftware.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZGCQiC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 12:38:02 -0400
Received: from localhost ([127.0.0.1] helo=[127.0.0.100])
	by acoma.photonsoftware.net with esmtpa (Exim 4.69)
	(envelope-from <ldone@hubstar.net>)
	id 1MMllu-0007qE-59
	for linux-media@vger.kernel.org; Fri, 03 Jul 2009 17:37:58 +0100
Message-ID: <4A4E33EC.6020703@hubstar.net>
Date: Fri, 03 Jul 2009 17:38:04 +0100
From: "ldone@hubstar.net" <ldone@hubstar.net>
Reply-To: "l d one"@hubstar.net
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx23885 HVR-1700 broken in v4l drivers vs standard kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi - apologies for posting twice, posted this as a reply rather than a new thread - doing well with mailing lists!

if I use stock kernel (Suse)  2.6.27.23-0.1 the card works, scans and
plays DVB-T channels.
if I use the latest v4l drivers the card is recognised, and picked up,
tune a channel, but cannot find any DVB-T channels.

I'm afraid I'm not sure what to look for there are quite a few structural changes to the code.

Thanks


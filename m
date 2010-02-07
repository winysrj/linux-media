Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:57590 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0BGN0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 08:26:12 -0500
Received: from [192.168.1.2] (unknown [88.249.178.198])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id E90CAA7B021
	for <linux-media@vger.kernel.org>; Sun,  7 Feb 2010 15:24:56 +0200 (EET)
Message-ID: <4B6EBF77.90508@pardus.org.tr>
Date: Sun, 07 Feb 2010 15:26:15 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Anything like compat-v4l?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The v4l-dvb tree moves so fast in terms of new drivers and support for new devices compared to the stable trees.
Massive changes are nearly only done through .3x merge windows. That is the correct behaviour but leaves distributions
without support for important drivers like e.g. mantis which has been merged into 2.6.33.

I've backported it to 2.6.31 but seen that the IR code was renamed/moved/rewritten, it took me quite time.

So isn't there anything like compat-v4l just like alsa-driver or compat-wireless to build bleeding edge v4l stuff
externally?

Regards,
Ozan Caglayan

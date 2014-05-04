Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54429 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753459AbaEDA31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 May 2014 20:29:27 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5253960093
	for <linux-media@vger.kernel.org>; Sun,  4 May 2014 03:29:24 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: smiapp: Minor improvements, early preparation for DT support
Date: Sun,  4 May 2014 03:31:54 +0300
Message-Id: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches prepare the smiapp driver for DT support later on. The
regulator name will be lower case. Wrong error values were returned in probe
--- instead pass them through, as -EPROBE_DEFER may have a quantifiable
practical effect compared to other error codes.

-- 
Kind regards,
Sakari


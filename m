Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55054 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755801AbaIQUpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:32 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 52BA160098
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/17] smiapp and smiapp-pll: more robust parameter handling, cleanups
Date: Wed, 17 Sep 2014 23:45:24 +0300
Message-Id: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set brings several improvements to the smiapp driver and the smiapp PLL
calculator. Especially:

- Several cleanups and small fixes,
- only calculate the VT clock tree for sensors that have no OP tree (the OP
  constraits in pixel clock divider were not taken into account for VT
  clocks),
- fix a (harmless) lockdep warning in sensor initialisation,
- the PLL update is done if there has been a change in output BPP and
- maintain information on valid combinations of link frequencies and
  formats. What could happen was that if one chose a link frequency that was
  not possible for a given media bus format (or the other way around), the
  user was simply given an error with no hints on what could be wrong. The
  format is considered more important and the link rate is adjusted to suit
  the format if needed.

-- 
Kind regards,
Sakari


Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40806 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933144AbaLJVQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:38 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 25DDB60096
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:34 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/7] smiapp: Cleanups, small bugfixes
Date: Wed, 10 Dec 2014 23:16:13 +0200
Message-Id: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches contain cleanups, primarily in the sensor initialisation, and
replace the pll_flags quirk by a generic init quirk which, besides setting
pll flags, can be used to e.g. creating sensor specific controls.

-- 
Kind regards,
Sakari


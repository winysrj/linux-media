Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43526 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753698Ab2IOVls (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 17:41:48 -0400
Received: from [127.0.0.1] (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 85CB960099
	for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 00:41:44 +0300 (EEST)
Message-ID: <5054F66C.1050400@iki.fi>
Date: Sun, 16 Sep 2012 00:43:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] SMIA++ driver improvements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The first one of these two small patches fixes a minor issue in format 
enumeration from the sensor, whereas the second one provides the module 
identification information to the user space through a sysfs file.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

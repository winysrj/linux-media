Return-path: <linux-media-owner@vger.kernel.org>
Received: from email.edvz.uni-linz.ac.at ([140.78.3.65]:26439 "EHLO
	email.uni-linz.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGNOYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 10:24:51 -0400
Received: from caddo.bayou.uni-linz.ac.at (shrimp.bayou.uni-linz.ac.at [140.78.125.6])
	by email.uni-linz.ac.at (Postfix) with ESMTP id 569B419B8A7
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 16:16:25 +0200 (CEST)
Received: from caddo.bayou.uni-linz.ac.at (caddo.bayou.uni-linz.ac.at [127.0.0.1])
	by caddo.bayou.uni-linz.ac.at (8.14.9/8.14.9/Debian-4) with ESMTP id u6EEGPcp005795
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 16:16:25 +0200
Received: (from stegall@localhost)
	by caddo.bayou.uni-linz.ac.at (8.14.9/8.14.9/Submit) id u6EEGONk005794
	for linux-media@vger.kernel.org; Thu, 14 Jul 2016 16:16:24 +0200
Date: Thu, 14 Jul 2016 16:16:24 +0200
From: Charles Stegall <stegall@bayou.uni-linz.ac.at>
To: linux-media@vger.kernel.org
Subject: uvcvideo
Message-ID: <20160714141624.GA5718@bayou.uni-linz.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


this happens ...

modprobe uvcvideo
modprobe: ERROR: could not insert 'uvcvideo': Exec format error

and /dev/video0 is not created

I followed, very carefully, several times,  the directions on

https://linuxtv.org/wiki/index.php?title=TBS_driver_installation&action=info

kernel source 4.6.4

the module I wanted saa716x_budget   works very well, but ...

hitherto, I had never used a usb camera at the same time but
this happens


modprobe uvcvideo
modprobe: ERROR: could not insert 'uvcvideo': Exec format error

so none of my usb cameras work if the directions are followed

on the plain vanilla 4.6.4 kernel, the cameras work ...
so, probably not a kernel bug ?


the same thing happens on some earlier kernels


thank you, Charles Stegall



-- 


Charles Stegall
stegall@bayou.uni-linz.ac.at


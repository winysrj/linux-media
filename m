Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39290 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753559Ab3AVQXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:23:48 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id C92E7601E6
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 18:23:45 +0200 (EET)
Date: Tue, 22 Jan 2013 18:23:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Compat IOCTL handler for Media controller
Message-ID: <20130122162343.GO13641@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I noticed recently that we're missing the compat IOCTL handling in Media
controller API to support 32-bit binaries on 64-bit systems. I guess the
issue hasn't bitten anyone too badly since this hasn't been noticed earlier.

I can think of the reasons, too: Media controller is primarily used on
embedded systems that are still mainly 32-bit and the binaries are
targeted to those very systems specifically.

I noticed this since I'm currently running my 32-bit Debian system on a
64-bit kernel (I like to run 64-bit virtual machines but I'm lazy to
update; waiting for multiarch) so my native media-ctl binary just failed
to report anything about a UVC device Laurent kindly lended me.

The patchset implements separate compat ioctl handling and splits link
enumeration handling into 32-bit and 64-bit portions.

Many thanks to Laurent for testing these patches!

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi

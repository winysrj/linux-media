Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53047 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045AbaKHXKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:10:11 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id BA07960097
	for <linux-media@vger.kernel.org>; Sun,  9 Nov 2014 01:10:09 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/10] smiapp OF support
Date: Sun,  9 Nov 2014 01:09:21 +0200
Message-Id: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patchset adds support for Device tree in the smiapp driver. Platform   
data support is retained as well. The actual DT related changes are
prepended by a few simple cleanups.

A new link-frequency property is defined in video-interfaces.txt, as this is
hardly something which is specific to the SMIA compliant sensors.
                                   
-- 
Kind regards,
Sakari

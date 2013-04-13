Return-path: <linux-media-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:50068 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3DMPI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 11:08:57 -0400
From: Jakob Haufe <sur5r@sur5r.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add support for Delock 61959 and its remote control
Date: Sat, 13 Apr 2013 17:03:35 +0200
Message-Id: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This time for real with all bells and whistles:

Delock 61959 is a relabeled MexMedia UB-425TC with a different USB ID and a
different remote.

Patch 1 adds the keytable for the remote control and patch 2 adds support for
the device itself. I'm reusing maxmedia_ub425_tc as I didn't want to duplicate
it without need.

DVB-T is not working (yet) because of the DRX-K firmware issue.


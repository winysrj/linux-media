Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:42371 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab2CKOIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 10:08:52 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Mapping frontends to demuxes
Date: Sun, 11 Mar 2012 16:08:48 +0200
Cc: vlc-devel@videolan.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203111608.48843.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hello linux-media folks,

With the new multi-system frontend capability API, how are frontend and 
demux/dvr devices paired? Should userspace assume that frontendX corresponds 
to demuxX and dvrX (and caX and netX?) within a multifrontend adaptor?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis

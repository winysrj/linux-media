Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:42429 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768657Ab2KOTDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 14:03:08 -0500
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org, lkml@vger.kernel.org
Subject: Linux v3.7-rc2 DVB breaks user space compilation
Date: Thu, 15 Nov 2012 21:03:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211152103.04468@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hello,

The following patch broke our userspace software builds. While it does 
preserve BINARY compatibility, it breaks SOURCE compatibility as the parameter 
names have changed. I don't see the rationale for breaking compatibility in 
the patch description.

Please consider reverting to the old names. Thank you.

commit 287cefd096b124874dc4d6d155f53547c0654860
Author: Evgeny Plehov <EvgenyPlehov@ukr.net>
Date:   Thu Sep 13 10:13:30 2012 -0300

    [media] dvb_frontend: add multistream support
    
    Unify multistream support at the DVBAPI: several delivery systems
    allow it. Yet, each one had its own name. So, instead of adding
    a third version of this field, remove the per-standard naming,
    unifying it into a common name.
    
    The legacy code number can still be used by old applications.
    
    Version increased to 5.8.
    
    [mchehab@redhat.com: joined the va1j5jf007s patch, in order to
     avoid compilation breakage]
    Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-- 
Rémi Denis-Courmont
http://www.remlab.net/

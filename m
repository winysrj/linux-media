Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49935 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0BJSfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:24 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 82C4F90076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:25 +0100 (CET)
Date: Wed, 10 Feb 2010 19:37:00 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 4 of 7] czap: use %m modifier in sscanf instead of %a
Message-ID: <20100210183700.GO8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/czap.c |  2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)



--OROCMA9jn6tkzFBc
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-4.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265823785 -3600
# Node ID 0163e837905411bb9932bb65fecde5735e5bd7e9
# Parent  c1e4c34da4fd395755d98dbbdd7af2950d723a9d
czap: use %m modifier in sscanf instead of %a

%a is a old glibc extension and conflicts with
the floating point modifier %a in C99

diff -r c1e4c34da4fd -r 0163e8379054 util/szap/czap.c
--- a/util/szap/czap.c	Wed Feb 10 18:42:59 2010 +0100
+++ b/util/szap/czap.c	Wed Feb 10 18:43:05 2010 +0100
@@ -143,7 +143,7 @@
 	}
 	printf("%3d %s", chan_no, chan);
 
-	if ((sscanf(chan, "%a[^:]:%d:%a[^:]:%d:%a[^:]:%a[^:]:%d:%d\n",
+	if ((sscanf(chan, "%m[^:]:%d:%m[^:]:%d:%m[^:]:%m[^:]:%d:%d\n",
 				&name, &frontend->frequency,
 				&inv, &frontend->u.qam.symbol_rate,
 				&fec, &mod, vpid, apid) != 8)

--OROCMA9jn6tkzFBc--

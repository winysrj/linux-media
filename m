Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40252 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2DAPxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:53:34 -0400
Received: from pannekake.samfundet.no ([2001:700:300:1800::dddd] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1SEN5u-0001Tt-Bj
	for linux-media@vger.kernel.org; Sun, 01 Apr 2012 17:53:30 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.72)
	(envelope-from <sesse@samfundet.no>)
	id 1SEN5u-0008Ld-3d
	for linux-media@vger.kernel.org; Sun, 01 Apr 2012 17:53:30 +0200
Date: Sun, 1 Apr 2012 17:53:30 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Various fixes, hacks and patches for Mantis CA support.
Message-ID: <20120401155330.GA31901@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was asked to break up my large patch into several smaller,
Signed-off-by-marked changes. I've rebased against linux-2.6 master and done
some today; note that since not all of these changes are originally by me,
you will probably have to consider each one separately for inclusion
(although they largely make sense independently of each other).

My interest in this project is, unfortunately, waning, since it appears there
is no hardware documentation and very little active maintenance of the
driver, which means that getting it the final step of the way is going to be
hard (and probably not worth it). However, hopefully someone else will find
the patch set useful nevertheless.

/* Steinar */
-- 
Homepage: http://www.sesse.net/

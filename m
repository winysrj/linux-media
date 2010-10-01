Return-path: <mchehab@pedra>
Received: from smtp28.orange.fr ([80.12.242.101]:59184 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0JATzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 15:55:49 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id B563B800021C
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:47 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id A4611800028D
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:47 +0200 (CEST)
Received: from roazhon.bzh.lan (ARennes-256-1-120-172.w90-32.abo.wanadoo.fr [90.32.119.172])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id 6A5A7800021C
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:47 +0200 (CEST)
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T), v2
Date: Fri,  1 Oct 2010 21:55:42 +0200
Message-Id: <1285962943-20312-1-git-send-email-yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello All!

This patch adds support for the AverMedia AVerTV Red HD+ (aka A850T)
DVB-T USB stick, available (exclusively?) on the french market.

Changes since v1:
- move to its own device description
- rebase on top staging/v2.6.37 in the media_tree git tree

checkpatch.pl warns about two lines that are longer than 80 chars,
but I am not sure how to split them and still keep readable code.
Suggestions welcome. ;-)

Note: only the DVB-T reception has been tested, not the remote
controler part, as I do not use it. It may come later as I may
eventually need it.

Thanks to Antti for his suggestions and guidance. :-)

Regards,
Yann E. MORIN.



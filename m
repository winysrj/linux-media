Return-path: <mchehab@pedra>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:23354 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0I2V0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 17:26:43 -0400
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Wed, 29 Sep 2010 23:18:42 +0200
Message-Id: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello All!

This patch adds support for The AverMedia AVerTV Red HD+ (aka A850T)
DVB-T USB stick, available (exclusively?) on the french market.

checkpatch.pl warns about two lines that are longer then 80 chars, but
I am not sure how to split them and still keep readable code. Suggestions
welcome. ;-)

The patch is based off Mauro's linux-2.6 tree on git.kernel.org. On the
WiKi, there are references to the Hg tree on some pages, and references
to the git tree on other pages. The trees differ from each others, and
the git tree seemed more up-to-date wrt af9015. So I choosed the git tree.
If needed, I can rebase ontop the Hg tree.

Regards,
Yann E. MORIN.

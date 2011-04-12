Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab1DLUX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 16:23:29 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3CKNTM7013844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 16:23:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/2] [media] nuvoton-cir: support more hardware variants
Date: Tue, 12 Apr 2011 16:23:20 -0400
Message-Id: <1302639802-22723-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are some additional Nuvoton LPC Super I/O chips that report the PNP
device ID the nuvoton-cir driver binds to, and we *should* be able to
support them all. This gets us closer...

Jarod Wilson (2):
  [media] rc/nuvoton-cir: only warn about unknown chips
  [media] rc/nuvoton-cir: enable CIR on w83667hg chip variant

 drivers/media/rc/nuvoton-cir.c |   51 +++++++++++++++++++++++++++++++++------
 drivers/media/rc/nuvoton-cir.h |   13 ++++++++--
 2 files changed, 53 insertions(+), 11 deletions(-)


Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab0IHNUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 09:20:48 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o88DKmW6004745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 09:20:48 -0400
Received: from [10.11.11.235] (vpn-11-235.rdu.redhat.com [10.11.11.235])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o88DKk1d031311
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 09:20:48 -0400
Message-ID: <4C878DB1.9030703@redhat.com>
Date: Wed, 08 Sep 2010 10:20:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L/DVB: cx25821: fix gcc warning when compiled with
 allyesconfig
References: <853aa6f8137f702beb216b3aa1d31aff604f38f5.1283951980.git.mchehab@redhat.com>
In-Reply-To: <853aa6f8137f702beb216b3aa1d31aff604f38f5.1283951980.git.mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

drivers/staging/cx25821/cx25821-alsa.c:632: warning: ‘cx25821_audio_pci_tbl’ defined but not used

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index a43b188..095562c 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -629,7 +629,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static struct pci_device_id cx25821_audio_pci_tbl[] __devinitdata = {
+static const struct pci_device_id cx25821_audio_pci_tbl[] __devinitdata = {
 	{0x14f1, 0x0920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
-- 
1.7.1


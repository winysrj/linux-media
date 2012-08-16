Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:57397 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2HPOze (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 10:55:34 -0400
Message-ID: <502D09EC.9080504@netup.ru>
Date: Thu, 16 Aug 2012 18:55:40 +0400
From: ptqa <ptqa@netup.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Media <linux-media@vger.kernel.org>
CC: =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JHRg9GC0LrQtdC10LI=?=
	<abutkeev@netup.ru>, Abylai Ospan <aospan@netup.ru>
Subject: [PATCH] cx23885: fix pointer to structure for CAM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Mauro. Please, check our patch. Fixes problem with CAM, when 
after re-iinitialization CAM used old pointer to structure.

Signed-off-by: Anton Nurkin <ptqa@netup.ru>

---

  drivers/media/pci/cx23885/altera-ci.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.c 
b/drivers/media/pci/cx23885/altera-ci.c
index 1fa8927..1e73764 100644
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -724,6 +724,7 @@ int altera_ci_init(struct altera_ci_config *config, 
int ci_nr)
         if (temp_int != NULL) {
                 inter = temp_int->internal;
                 (inter->cis_used)++;
+                inter->fpga_rw = config->fpga_rw;
                 ci_dbg_print("%s: Find Internal Structure!\n", __func__);
         } else {
                 inter = kzalloc(sizeof(struct fpga_internal), GFP_KERNEL);
@@ -743,7 +744,6 @@ int altera_ci_init(struct altera_ci_config *config, 
int ci_nr)

         ci_dbg_print("%s: setting state = %p for ci = %d\n", __func__,
                                                 state, ci_nr - 1);
-       inter->state[ci_nr - 1] = state;
         state->internal = inter;
         state->nr = ci_nr - 1;

@@ -765,6 +765,8 @@ int altera_ci_init(struct altera_ci_config *config, 
int ci_nr)
         if (0 != ret)
                 goto err;

+       inter->state[ci_nr - 1] = state;
+
         altera_hw_filt_init(config, ci_nr);

         if (inter->strt_wrk) {


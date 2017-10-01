Return-path: <linux-media-owner@vger.kernel.org>
Received: from blatinox.fr ([51.254.120.209]:33832 "EHLO vps202351.ovh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751604AbdJATlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 15:41:13 -0400
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] media: staging: atomisp: use ARRAY_SIZE
Date: Sun,  1 Oct 2017 15:30:54 -0400
Message-Id: <20171001193101.8898-17-jeremy.lefaure@lse.epita.fr>
In-Reply-To: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the ARRAY_SIZE macro improves the readability of the code. Also,
it is useless to use a variable to store this constant calculated at
compile time.

Found with Coccinelle with the following semantic patch:
@r depends on (org || report)@
type T;
T[] E;
position p;
@@
(
 (sizeof(E)@p /sizeof(*E))
|
 (sizeof(E)@p /sizeof(E[...]))
|
 (sizeof(E)@p /sizeof(T))
)

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
---
 .../pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c       | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
index 17d3b7de93ba..98a2a3e9b3e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
@@ -22,6 +22,7 @@
 #include <assert_support.h>
 /* HRT_GDC_N */
 #include "gdc_device.h"
+#include <linux/kernel.h>
 
 /* This module provides a binary descriptions to used to find a binary. Since,
  * every stage is associated with a binary, it implicity helps stage
@@ -147,11 +148,9 @@ enum ia_css_err sh_css_bds_factor_get_numerator_denominator(
 	unsigned int *bds_factor_denominator)
 {
 	unsigned int i;
-	unsigned int bds_list_size = sizeof(bds_factors_list) /
-				sizeof(struct sh_css_bds_factor);
 
 	/* Loop over all bds factors until a match is found */
-	for (i = 0; i < bds_list_size; i++) {
+	for (i = 0; i < ARRAY_SIZE(bds_factors_list); i++) {
 		if (bds_factors_list[i].bds_factor == bds_factor) {
 			*bds_factor_numerator = bds_factors_list[i].numerator;
 			*bds_factor_denominator = bds_factors_list[i].denominator;
@@ -170,8 +169,6 @@ enum ia_css_err binarydesc_calculate_bds_factor(
 	unsigned int *bds_factor)
 {
 	unsigned int i;
-	unsigned int bds_list_size = sizeof(bds_factors_list) /
-	    sizeof(struct sh_css_bds_factor);
 	unsigned int in_w = input_res.width,
 	    in_h = input_res.height,
 	    out_w = output_res.width, out_h = output_res.height;
@@ -186,7 +183,7 @@ enum ia_css_err binarydesc_calculate_bds_factor(
 	assert(out_w != 0 && out_h != 0);
 
 	/* Loop over all bds factors until a match is found */
-	for (i = 0; i < bds_list_size; i++) {
+	for (i = 0; i < ARRAY_SIZE(bds_factors_list); i++) {
 		unsigned num = bds_factors_list[i].numerator;
 		unsigned den = bds_factors_list[i].denominator;
 
-- 
2.14.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:36934 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbdK0Mpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 07:45:43 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH v2 3/3] media: staging: atomisp: fixed some checkpatch integer type warnings.
Date: Mon, 27 Nov 2017 12:44:50 +0000
Message-Id: <20171127124450.28799-4-jeremy@azazel.net>
In-Reply-To: <20171127124450.28799-1-jeremy@azazel.net>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed the types of some arrays from int16_t to s16.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 25 +++++++++++-----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
index 47bb5042381b..af6c8688876d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
@@ -32,47 +32,46 @@
 #define NUMBER_OF_TCINV_POINTS 9
 #define NUMBER_OF_FCINV_POINTS 9
 
-static const int16_t chgrinv_x[NUMBER_OF_CHGRINV_POINTS] = {
+static const s16 chgrinv_x[NUMBER_OF_CHGRINV_POINTS] = {
 0, 16, 64, 144, 272, 448, 672, 976,
 1376, 1888, 2528, 3312, 4256, 5376, 6688};
 
-static const int16_t chgrinv_a[NUMBER_OF_CHGRINV_POINTS] = {
+static const s16 chgrinv_a[NUMBER_OF_CHGRINV_POINTS] = {
 -7171, -256, -29, -3456, -1071, -475, -189, -102,
 -48, -38, -10, -9, -7, -6, 0};
 
-static const int16_t chgrinv_b[NUMBER_OF_CHGRINV_POINTS] = {
+static const s16 chgrinv_b[NUMBER_OF_CHGRINV_POINTS] = {
 8191, 1021, 256, 114, 60, 37, 24, 17,
 12, 9, 6, 5, 4, 3, 2};
 
-static const int16_t chgrinv_c[NUMBER_OF_CHGRINV_POINTS] = {
+static const s16 chgrinv_c[NUMBER_OF_CHGRINV_POINTS] = {
 1, 1, 1, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0};
 
-static const int16_t tcinv_x[NUMBER_OF_TCINV_POINTS] = {
+static const s16 tcinv_x[NUMBER_OF_TCINV_POINTS] = {
 0, 4, 11, 23, 42, 68, 102, 148, 205};
 
-static const int16_t tcinv_a[NUMBER_OF_TCINV_POINTS] = {
+static const s16 tcinv_a[NUMBER_OF_TCINV_POINTS] = {
 -6364, -631, -126, -34, -13, -6, -4452, -2156, 0};
 
-static const int16_t tcinv_b[NUMBER_OF_TCINV_POINTS] = {
+static const s16 tcinv_b[NUMBER_OF_TCINV_POINTS] = {
 8191, 1828, 726, 352, 197, 121, 80, 55, 40};
 
-static const int16_t tcinv_c[NUMBER_OF_TCINV_POINTS] = {
+static const s16 tcinv_c[NUMBER_OF_TCINV_POINTS] = {
 1, 1, 1, 1, 1, 1, 0, 0, 0};
 
-static const int16_t fcinv_x[NUMBER_OF_FCINV_POINTS] = {
+static const s16 fcinv_x[NUMBER_OF_FCINV_POINTS] = {
 0, 80, 216, 456, 824, 1344, 2040, 2952, 4096};
 
-static const int16_t fcinv_a[NUMBER_OF_FCINV_POINTS] = {
+static const s16 fcinv_a[NUMBER_OF_FCINV_POINTS] = {
 -5244, -486, -86, -2849, -961, -400, -180, -86, 0};
 
-static const int16_t fcinv_b[NUMBER_OF_FCINV_POINTS] = {
+static const s16 fcinv_b[NUMBER_OF_FCINV_POINTS] = {
 8191, 1637, 607, 287, 159, 98, 64, 44, 32};
 
-static const int16_t fcinv_c[NUMBER_OF_FCINV_POINTS] = {
+static const s16 fcinv_c[NUMBER_OF_FCINV_POINTS] = {
 1, 1, 1, 0, 0, 0, 0, 0, 0};
 
-
 void
 ia_css_eed1_8_vmem_encode(
 	struct eed1_8_vmem_params *to,
-- 
2.15.0

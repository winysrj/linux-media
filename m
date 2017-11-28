Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:45302 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbdK1K2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 05:28:01 -0500
From: Jeremy Sowden <jeremy@azazel.net>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH v3 2/2] media: staging: atomisp: fixes for "symbol was not declared. Should it be static?" sparse warnings.
Date: Tue, 28 Nov 2017 10:27:26 +0000
Message-Id: <20171128102726.30542-3-jeremy@azazel.net>
In-Reply-To: <20171128102726.30542-1-jeremy@azazel.net>
References: <20171127190938.73c6b15a@alans-desktop>
 <20171128102726.30542-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defined some const arrays as static since they don't need external linkage.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
index 682f8b709ff9..47bb5042381b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
@@ -32,44 +32,44 @@
 #define NUMBER_OF_TCINV_POINTS 9
 #define NUMBER_OF_FCINV_POINTS 9
 
-const int16_t chgrinv_x[NUMBER_OF_CHGRINV_POINTS] = {
+static const int16_t chgrinv_x[NUMBER_OF_CHGRINV_POINTS] = {
 0, 16, 64, 144, 272, 448, 672, 976,
 1376, 1888, 2528, 3312, 4256, 5376, 6688};
 
-const int16_t chgrinv_a[NUMBER_OF_CHGRINV_POINTS] = {
+static const int16_t chgrinv_a[NUMBER_OF_CHGRINV_POINTS] = {
 -7171, -256, -29, -3456, -1071, -475, -189, -102,
 -48, -38, -10, -9, -7, -6, 0};
 
-const int16_t chgrinv_b[NUMBER_OF_CHGRINV_POINTS] = {
+static const int16_t chgrinv_b[NUMBER_OF_CHGRINV_POINTS] = {
 8191, 1021, 256, 114, 60, 37, 24, 17,
 12, 9, 6, 5, 4, 3, 2};
 
-const int16_t chgrinv_c[NUMBER_OF_CHGRINV_POINTS] = {
+static const int16_t chgrinv_c[NUMBER_OF_CHGRINV_POINTS] = {
 1, 1, 1, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0};
 
-const int16_t tcinv_x[NUMBER_OF_TCINV_POINTS] = {
+static const int16_t tcinv_x[NUMBER_OF_TCINV_POINTS] = {
 0, 4, 11, 23, 42, 68, 102, 148, 205};
 
-const int16_t tcinv_a[NUMBER_OF_TCINV_POINTS] = {
+static const int16_t tcinv_a[NUMBER_OF_TCINV_POINTS] = {
 -6364, -631, -126, -34, -13, -6, -4452, -2156, 0};
 
-const int16_t tcinv_b[NUMBER_OF_TCINV_POINTS] = {
+static const int16_t tcinv_b[NUMBER_OF_TCINV_POINTS] = {
 8191, 1828, 726, 352, 197, 121, 80, 55, 40};
 
-const int16_t tcinv_c[NUMBER_OF_TCINV_POINTS] = {
+static const int16_t tcinv_c[NUMBER_OF_TCINV_POINTS] = {
 1, 1, 1, 1, 1, 1, 0, 0, 0};
 
-const int16_t fcinv_x[NUMBER_OF_FCINV_POINTS] = {
+static const int16_t fcinv_x[NUMBER_OF_FCINV_POINTS] = {
 0, 80, 216, 456, 824, 1344, 2040, 2952, 4096};
 
-const int16_t fcinv_a[NUMBER_OF_FCINV_POINTS] = {
+static const int16_t fcinv_a[NUMBER_OF_FCINV_POINTS] = {
 -5244, -486, -86, -2849, -961, -400, -180, -86, 0};
 
-const int16_t fcinv_b[NUMBER_OF_FCINV_POINTS] = {
+static const int16_t fcinv_b[NUMBER_OF_FCINV_POINTS] = {
 8191, 1637, 607, 287, 159, 98, 64, 44, 32};
 
-const int16_t fcinv_c[NUMBER_OF_FCINV_POINTS] = {
+static const int16_t fcinv_c[NUMBER_OF_FCINV_POINTS] = {
 1, 1, 1, 0, 0, 0, 0, 0, 0};
 
 
-- 
2.15.0

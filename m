Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaCCKIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:07 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 29/79] [media] drx-j: Remove typedefs in drxj.c
Date: Mon,  3 Mar 2014 07:06:23 -0300
Message-Id: <1393841233-24840-30-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove three typedefs from drxj.c, using the following script:

use File::Find;
use strict;

my $dir = shift or die "need a dir";
my $type = shift or die "need type";
my $var = shift or die "need var";

sub handle_file {
	my $file = shift;

	my $out;

	open IN, $file or die "can't open $file";
	$out .= $_ while (<IN>);
	close IN;

	$out =~ s/\btypedef\s+($type)\s+\{([\d\D]+?)\s*\}\s+\b($var)[^\;]+\;/$type $var \{\2\};/;

        # This replaces the typedef declaration for a simple struct declaration - style 1

        # This replaces the typedef declaration for a simple struct declaration - style 2

	# Replace struct occurrences

	$out =~ s,\b($var)_t\s+,$type \1 ,g;
	$out =~ s,\bp_*($var)_t\s+,$type \1 *,g;
	$out =~ s,\b($var)_t\b,$type \1,g;
	$out =~ s,\bp_*($var)_t\b,$type \1 *,g;

	open OUT, ">$file" or die "can't open $file";
	print OUT $out;
	close OUT;
}

sub parse_dir {
	my $file = $File::Find::name;

	return if (!($file =~ /.[ch]$/));

	handle_file $file;
}

find({wanted => \&parse_dir, no_chdir => 1}, $dir);

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index f6361b669e67..c5def7d2bcba 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1050,37 +1050,34 @@ struct drx_aud_data drxj_default_aud_data_g = {
 /*-----------------------------------------------------------------------------
 STRUCTURES
 ----------------------------------------------------------------------------*/
-typedef struct {
+struct drxjeq_stat {
 	u16 eq_mse;
 	u8 eq_mode;
 	u8 eq_ctrl;
-	u8 eq_stat;
-} drxjeq_stat_t, *pdrxjeq_stat_t;
+	u8 eq_stat;};
 
 /* HI command */
-typedef struct {
+struct drxj_hi_cmd {
 	u16 cmd;
 	u16 param1;
 	u16 param2;
 	u16 param3;
 	u16 param4;
 	u16 param5;
-	u16 param6;
-} drxj_hi_cmd_t, *pdrxj_hi_cmd_t;
+	u16 param6;};
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 /*============================================================================*/
 /*=== MICROCODE RELATED STRUCTURES ===========================================*/
 /*============================================================================*/
 
-typedef struct {
+struct drxu_code_block_hdr {
 	u32 addr;
 	u16 size;
 	u16 flags;		/* bit[15..2]=reserved,
 				   bit[1]= compression on/off
 				   bit[0]= CRC on/off */
-	u16 CRC;
-} drxu_code_block_hdr_t, *pdrxu_code_block_hdr_t;
+	u16 CRC;};
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
 /*-----------------------------------------------------------------------------
@@ -1089,7 +1086,7 @@ FUNCTIONS
 /* Some prototypes */
 static int
 hi_command(struct i2c_device_addr *dev_addr,
-	   const pdrxj_hi_cmd_t cmd, u16 *result);
+	   const struct drxj_hi_cmd *cmd, u16 *result);
 
 static int
 ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat);
@@ -2041,7 +2038,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 					  u16 datasize,
 					  u8 *data, bool read_flag)
 {
-	drxj_hi_cmd_t hi_cmd;
+	struct drxj_hi_cmd hi_cmd;
 	int rc;
 	u16 word;
 	u16 dummy = 0;
@@ -2171,7 +2168,7 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 static int hi_cfg_command(const struct drx_demod_instance *demod)
 {
 	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
-	drxj_hi_cmd_t hi_cmd;
+	struct drxj_hi_cmd hi_cmd;
 	u16 result = 0;
 	int rc;
 
@@ -2212,7 +2209,7 @@ rw_error:
 *
 */
 static int
-hi_command(struct i2c_device_addr *dev_addr, const pdrxj_hi_cmd_t cmd, u16 *result)
+hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16 *result)
 {
 	u16 wait_cmd = 0;
 	u16 nr_retries = 0;
@@ -4334,7 +4331,7 @@ rw_error:
 static int
 ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 {
-	drxj_hi_cmd_t hi_cmd;
+	struct drxj_hi_cmd hi_cmd;
 	u16 result = 0;
 
 	/* check arguments */
@@ -19141,7 +19138,7 @@ ctrl_u_code_upload(struct drx_demod_instance *demod,
 
 	/* Process microcode blocks */
 	for (i = 0; i < mc_nr_of_blks; i++) {
-		drxu_code_block_hdr_t block_hdr;
+		struct drxu_code_block_hdr block_hdr;
 		u16 mc_block_nr_bytes = 0;
 
 		/* Process block header */
-- 
1.8.5.3


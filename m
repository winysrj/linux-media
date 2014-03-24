Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaCXWJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 18:09:53 -0400
Date: Tue, 25 Mar 2014 06:09:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 248/499] WARNING: adding a line without
 newline at end of file
Message-ID: <5330ad26.2k2STjLkW7R1tiGe%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   8432164ddf7bfe40748ac49995356ab4dfda43b7
commit: b240eacdd536bac23c9d48dfc3d527ed6870ddad [248/499] [media] drx-j: get rid of drx_driver.c

scripts/checkpatch.pl 0001-media-drx-j-get-rid-of-drx_driver.c.patch
# many are suggestions rather than must-fix

WARNING: line over 80 characters
#865: drivers/media/dvb-frontends/drx39xyj/drxj.c:20739:
+				if (block_hdr.addr + 2 * sizeof(u16) + 2 * sizeof (u32) > size)

WARNING: space prohibited between function name and open parenthesis '('
#865: drivers/media/dvb-frontends/drx39xyj/drxj.c:20739:
+				if (block_hdr.addr + 2 * sizeof(u16) + 2 * sizeof (u32) > size)

WARNING: line over 80 characters
#876: drivers/media/dvb-frontends/drx39xyj/drxj.c:20750:
+				DRX_ATTR_MCRECORD(demod).mc_dev_type = mc_dev_type;

WARNING: line over 80 characters
#877: drivers/media/dvb-frontends/drx39xyj/drxj.c:20751:
+				DRX_ATTR_MCRECORD(demod).mc_version = mc_version;

WARNING: line over 80 characters
#878: drivers/media/dvb-frontends/drx39xyj/drxj.c:20752:
+				DRX_ATTR_MCRECORD(demod).mc_base_version = mc_base_version;

WARNING: line over 80 characters
#881: drivers/media/dvb-frontends/drx39xyj/drxj.c:20755:
+					mc_dev_type, mc_version, mc_base_version);

WARNING: please, no space before tabs
#910: drivers/media/dvb-frontends/drx39xyj/drxj.c:20784:
+ * ^I-EINVAL:$

WARNING: line over 80 characters
#1011: drivers/media/dvb-frontends/drx39xyj/drxj.c:20885:
+		     (block_hdr.CRC != drx_u_code_compute_crc(mc_data, block_hdr.size)))

WARNING: line over 80 characters
#1058: drivers/media/dvb-frontends/drx39xyj/drxj.c:20932:
+					       (unsigned)(mc_data - mc_data_init));

ERROR: spaces required around that '=' (ctx:WxV)
#1062: drivers/media/dvb-frontends/drx39xyj/drxj.c:20936:
+				result =drxbsp_hst_memcmp(curr_ptr,
 				       ^

WARNING: line over 80 characters
#1068: drivers/media/dvb-frontends/drx39xyj/drxj.c:20942:
+					       (unsigned)(mc_data - mc_data_init));

ERROR: spaces required around that '=' (ctx:WxO)
#1073: drivers/media/dvb-frontends/drx39xyj/drxj.c:20947:
+				curr_ptr =&(curr_ptr[bytes_to_comp]);
 				         ^

ERROR: space required before that '&' (ctx:OxV)
#1073: drivers/media/dvb-frontends/drx39xyj/drxj.c:20947:
+				curr_ptr =&(curr_ptr[bytes_to_comp]);
 				          ^

ERROR: spaces required around that '-=' (ctx:WxV)
#1074: drivers/media/dvb-frontends/drx39xyj/drxj.c:20948:
+				bytes_left -=((u32) bytes_to_comp);
 				           ^

WARNING: static char array declaration should probably be static const char
#1109: drivers/media/dvb-frontends/drx39xyj/drxj.c:20983:
+	static char drx_driver_core_module_name[] = "Core driver";

WARNING: line over 80 characters
#1144: drivers/media/dvb-frontends/drx39xyj/drxj.c:21018:
+		struct drx_version_list *current_list_element = demod_version_list;

WARNING: line over 80 characters
#1281: drivers/media/dvb-frontends/drx39xyj/drxj.c:21155:
+		return drx_ctrl_version(demod, (struct drx_version_list **)ctrl_data);

WARNING: line over 80 characters
#1307: drivers/media/dvb-frontends/drx39xyj/drxj.c:21181:
+						 (struct drxu_code_info *)ctrl_data,

WARNING: adding a line without newline at end of file
#1322: drivers/media/dvb-frontends/drx39xyj/drxj.c:21196:
+}

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

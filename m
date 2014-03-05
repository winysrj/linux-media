Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbaCEBcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 20:32:33 -0500
Date: Wed, 05 Mar 2014 09:32:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 463/499]
 drivers/media/dvb-frontends/drx39xyj/drxj.c:20670:34: sparse: cast to
 restricted __be16
Message-ID: <53167eaa.jU7XftocOOJCIWPu%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   59432be1c7fbf2a4f608850855ff649bee0f7b3b
commit: b240eacdd536bac23c9d48dfc3d527ed6870ddad [463/499] [media] drx-j: get rid of drx_driver.c
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/media/dvb-frontends/drx39xyj/drxj.c:21196:1: sparse: no newline at end of file
   drivers/media/dvb-frontends/drx39xyj/drxj.c:611:6: sparse: symbol 'drx_dap_drxj_module_name' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:612:6: sparse: symbol 'drx_dap_drxj_version_text' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:614:20: sparse: symbol 'drx_dap_drxj_version' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:998:21: sparse: symbol 'drxj_default_aud_data_g' was not declared. Should it be static?
   drivers/media/dvb-frontends/drx39xyj/drxj.c:16591:68: sparse: dubious: x & !y
   drivers/media/dvb-frontends/drx39xyj/drxj.c:16609:68: sparse: dubious: x & !y
   drivers/media/dvb-frontends/drx39xyj/drxj.c:16628:68: sparse: dubious: x & !y
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20670:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20670:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20670:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20670:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20697:29: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20697:29: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20697:29: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20697:29: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20715:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20717:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20717:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20717:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20717:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20719:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20719:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20719:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20719:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20721:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20721:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20721:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20721:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20735:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20735:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20735:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20735:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20743:47: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20745:46: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20747:51: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20831:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20831:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20831:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20831:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20833:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20833:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20833:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20833:25: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20866:34: sparse: cast to restricted __be32
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20868:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20868:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20868:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20868:34: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20870:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20870:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20870:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20870:35: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20872:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20872:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20872:33: sparse: cast to restricted __be16
>> drivers/media/dvb-frontends/drx39xyj/drxj.c:20872:33: sparse: cast to restricted __be16
   drivers/media/dvb-frontends/drx39xyj/drxj.c:13921:27: sparse: cast truncates bits from constant value (ffff00ff becomes ff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:13941:24: sparse: cast truncates bits from constant value (ffff3fff becomes 3fff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:14991:31: sparse: cast truncates bits from constant value (ffff00ff becomes ff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:15041:26: sparse: cast truncates bits from constant value (ffff0000 becomes 0)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:15118:33: sparse: cast truncates bits from constant value (ffff7fff becomes 7fff)
   drivers/media/dvb-frontends/drx39xyj/drxj.c:15717:26: sparse: cast truncates bits from constant value (ffff7fff becomes 7fff)

vim +20670 drivers/media/dvb-frontends/drx39xyj/drxj.c

 20664		u16 i = 0;
 20665		u16 j = 0;
 20666		u32 crc_word = 0;
 20667		u32 carry = 0;
 20668	
 20669		while (i < nr_words) {
 20670			crc_word |= (u32)be16_to_cpu(*(u32 *)(block_data));
 20671			for (j = 0; j < 16; j++) {
 20672				crc_word <<= 1;
 20673				if (carry != 0)
 20674					crc_word ^= 0x80050000UL;
 20675				carry = crc_word & 0x80000000UL;
 20676			}
 20677			i++;
 20678			block_data += (sizeof(u16));
 20679		}
 20680		return (u16)(crc_word >> 16);
 20681	}
 20682	
 20683	/**
 20684	 * drx_check_firmware - checks if the loaded firmware is valid
 20685	 *
 20686	 * @demod:	demod structure
 20687	 * @mc_data:	pointer to the start of the firmware
 20688	 * @size:	firmware size
 20689	 */
 20690	static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 20691				  unsigned size)
 20692	{
 20693		struct drxu_code_block_hdr block_hdr;
 20694		int i;
 20695		unsigned count = 2 * sizeof(u16);
 20696		u32 mc_dev_type, mc_version, mc_base_version;
 20697		u16 mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data + sizeof(u16)));
 20698	
 20699		/*
 20700		 * Scan microcode blocks first for version info
 20701		 * and firmware check
 20702		 */
 20703	
 20704		/* Clear version block */
 20705		DRX_ATTR_MCRECORD(demod).aux_type = 0;
 20706		DRX_ATTR_MCRECORD(demod).mc_dev_type = 0;
 20707		DRX_ATTR_MCRECORD(demod).mc_version = 0;
 20708		DRX_ATTR_MCRECORD(demod).mc_base_version = 0;
 20709	
 20710		for (i = 0; i < mc_nr_of_blks; i++) {
 20711			if (count + 3 * sizeof(u16) + sizeof(u32) > size)
 20712				goto eof;
 20713	
 20714			/* Process block header */
 20715			block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data + count));
 20716			count += sizeof(u32);
 20717			block_hdr.size = be16_to_cpu(*(u32 *)(mc_data + count));
 20718			count += sizeof(u16);
 20719			block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data + count));
 20720			count += sizeof(u16);
 20721			block_hdr.CRC = be16_to_cpu(*(u32 *)(mc_data + count));
 20722			count += sizeof(u16);
 20723	
 20724			pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
 20725				count, block_hdr.addr, block_hdr.size, block_hdr.flags,
 20726				block_hdr.CRC);
 20727	
 20728			if (block_hdr.flags & 0x8) {
 20729				u8 *auxblk = ((void *)mc_data) + block_hdr.addr;
 20730				u16 auxtype;
 20731	
 20732				if (block_hdr.addr + sizeof(u16) > size)
 20733					goto eof;
 20734	
 20735				auxtype = be16_to_cpu(*(u32 *)(auxblk));
 20736	
 20737				/* Aux block. Check type */
 20738				if (DRX_ISMCVERTYPE(auxtype)) {
 20739					if (block_hdr.addr + 2 * sizeof(u16) + 2 * sizeof (u32) > size)
 20740						goto eof;
 20741	
 20742					auxblk += sizeof(u16);
 20743					mc_dev_type = be32_to_cpu(*(u32 *)(auxblk));
 20744					auxblk += sizeof(u32);
 20745					mc_version = be32_to_cpu(*(u32 *)(auxblk));
 20746					auxblk += sizeof(u32);
 20747					mc_base_version = be32_to_cpu(*(u32 *)(auxblk));
 20748	
 20749					DRX_ATTR_MCRECORD(demod).aux_type = auxtype;
 20750					DRX_ATTR_MCRECORD(demod).mc_dev_type = mc_dev_type;
 20751					DRX_ATTR_MCRECORD(demod).mc_version = mc_version;
 20752					DRX_ATTR_MCRECORD(demod).mc_base_version = mc_base_version;
 20753	
 20754					pr_info("Firmware dev %x, ver %x, base ver %x\n",
 20755						mc_dev_type, mc_version, mc_base_version);
 20756	
 20757				}
 20758			} else if (count + block_hdr.size * sizeof(u16) > size)
 20759				goto eof;
 20760	
 20761			count += block_hdr.size * sizeof(u16);
 20762		}
 20763		return 0;
 20764	eof:
 20765		pr_err("Firmware is truncated at pos %u/%u\n", count, size);
 20766		return -EINVAL;
 20767	}
 20768	
 20769	/**
 20770	 * drx_ctrl_u_code - Handle microcode upload or verify.
 20771	 * @dev_addr: Address of device.
 20772	 * @mc_info:  Pointer to information about microcode data.
 20773	 * @action:  Either UCODE_UPLOAD or UCODE_VERIFY
 20774	 *
 20775	 * This function returns:
 20776	 *	0:
 20777	 *		- In case of UCODE_UPLOAD: code is successfully uploaded.
 20778	 *               - In case of UCODE_VERIFY: image on device is equal to
 20779	 *		  image provided to this control function.
 20780	 *	-EIO:
 20781	 *		- In case of UCODE_UPLOAD: I2C error.
 20782	 *		- In case of UCODE_VERIFY: I2C error or image on device
 20783	 *		  is not equal to image provided to this control function.
 20784	 * 	-EINVAL:
 20785	 *		- Invalid arguments.
 20786	 *		- Provided image is corrupt
 20787	 */
 20788	static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 20789			       struct drxu_code_info *mc_info,
 20790			       enum drxu_code_action action)
 20791	{
 20792		struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 20793		int rc;
 20794		u16 i = 0;
 20795		u16 mc_nr_of_blks = 0;
 20796		u16 mc_magic_word = 0;
 20797		const u8 *mc_data_init = NULL;
 20798		u8 *mc_data = NULL;
 20799		unsigned size;
 20800		char *mc_file = mc_info->mc_file;
 20801	
 20802		/* Check arguments */
 20803		if (!mc_info || !mc_file)
 20804			return -EINVAL;
 20805	
 20806		if (!demod->firmware) {
 20807			const struct firmware *fw = NULL;
 20808	
 20809			rc = request_firmware(&fw, mc_file, demod->i2c->dev.parent);
 20810			if (rc < 0) {
 20811				pr_err("Couldn't read firmware %s\n", mc_file);
 20812				return -ENOENT;
 20813			}
 20814			demod->firmware = fw;
 20815	
 20816			if (demod->firmware->size < 2 * sizeof(u16)) {
 20817				rc = -EINVAL;
 20818				pr_err("Firmware is too short!\n");
 20819				goto release;
 20820			}
 20821	
 20822			pr_info("Firmware %s, size %zu\n",
 20823				mc_file, demod->firmware->size);
 20824		}
 20825	
 20826		mc_data_init = demod->firmware->data;
 20827		size = demod->firmware->size;
 20828	
 20829		mc_data = (void *)mc_data_init;
 20830		/* Check data */
 20831		mc_magic_word = be16_to_cpu(*(u32 *)(mc_data));
 20832		mc_data += sizeof(u16);
 20833		mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data));
 20834		mc_data += sizeof(u16);
 20835	
 20836		if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
 20837			rc = -EINVAL;
 20838			pr_err("Firmware magic word doesn't match\n");
 20839			goto release;
 20840		}
 20841	
 20842		if (action == UCODE_UPLOAD) {
 20843			rc = drx_check_firmware(demod, (u8 *)mc_data_init, size);
 20844			if (rc)
 20845				goto release;
 20846	
 20847			/* After scanning, validate the microcode.
 20848			   It is also valid if no validation control exists.
 20849			 */
 20850			rc = drx_ctrl(demod, DRX_CTRL_VALIDATE_UCODE, NULL);
 20851			if (rc != 0 && rc != -ENOTSUPP) {
 20852				pr_err("Validate ucode not supported\n");
 20853				return rc;
 20854			}
 20855			pr_info("Uploading firmware %s\n", mc_file);
 20856		} else if (action == UCODE_VERIFY) {
 20857			pr_info("Verifying if firmware upload was ok.\n");
 20858		}
 20859	
 20860		/* Process microcode blocks */
 20861		for (i = 0; i < mc_nr_of_blks; i++) {
 20862			struct drxu_code_block_hdr block_hdr;
 20863			u16 mc_block_nr_bytes = 0;
 20864	
 20865			/* Process block header */
 20866			block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data));
 20867			mc_data += sizeof(u32);
 20868			block_hdr.size = be16_to_cpu(*(u32 *)(mc_data));
 20869			mc_data += sizeof(u16);
 20870			block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data));
 20871			mc_data += sizeof(u16);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbJAWRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:43 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sergey Kozlov <serjk@netup.ru>
Subject: [PATCH 3/7] [media] netup_unidvb: remove most of the sparse warnings
Date: Thu,  1 Oct 2015 19:17:25 -0300
Message-Id: <d91b1d912e9d856afb062c1a985e8c0b561f6c87.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a mess at the namespace on netup_unidvb:

drivers/media/pci/netup_unidvb/netup_unidvb_core.c:192:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:192:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:192:41:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:194:26: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:194:26: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:194:26:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:194:26:    got unsigned short [usertype] *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:196:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:196:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:196:41:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:198:26: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:198:26: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:198:26:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:198:26:    got unsigned short [usertype] *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:37:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:210:37:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:211:32: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:211:32:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:211:32:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:213:33: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:213:33:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:213:33:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:528:49: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:528:49:    expected void const volatile [noderef] <asn:2>*src
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:528:49:    got unsigned char [usertype] *
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:541:49: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:541:49:    expected void const volatile [noderef] <asn:2>*src
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:541:49:    got unsigned char [usertype] *
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:647:22: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:647:22:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:647:22:    got unsigned char [usertype] *addr_virt
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:650:22: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:654:59: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:654:59:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:654:59:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:56: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:56:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:655:56:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:656:23: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:656:23:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:656:23:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:658:31: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:658:31:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:658:31:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:660:33: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:660:33:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:660:33:    got restricted __le32 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:81:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:82:38:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:104:33:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:105:47:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:112:33:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:113:47:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:132:36:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:133:32:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:134:32:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:135:32:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:136:27:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:137:27:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:144:28:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:150:34:    got unsigned char *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:157:34:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:158:29:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:165:35:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:170:34:    got unsigned char *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:181:34:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:182:29:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:189:29:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:191:37:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:192:35:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:194:21:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:195:9:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:205:47:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:206:29:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:272:53:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:274:53:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c:323:22: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:229:38:    got unsigned short [usertype] *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:89:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:96:46:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:97:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:98:49:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:116:44:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:117:23:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48:    expected void volatile [noderef] <asn:2>*dst
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:132:48:    got unsigned char *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:136:46:    got unsigned char *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:144:37:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:145:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52:    expected void const volatile [noderef] <asn:2>*src
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:154:52:    got unsigned char *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:205:23: warning: cast removes address space of expression
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:206:24:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:243:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:244:46:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25: warning: incorrect type in argument 1 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:245:25:    got restricted __le16 *<noident>
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:246:49: warning: incorrect type in argument 2 (different address spaces)
drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:246:49:    expected void volatile [noderef] <asn:2>*addr

Fix the above sparse warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb.h b/drivers/media/pci/netup_unidvb/netup_unidvb.h
index fa951102d7fb..a67b28111905 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb.h
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb.h
@@ -54,7 +54,7 @@ struct netup_dma {
 	u8			num;
 	spinlock_t		lock;
 	struct netup_unidvb_dev	*ndev;
-	struct netup_dma_regs	*regs;
+	struct netup_dma_regs __iomem *regs;
 	u32			ring_buffer_size;
 	u8			*addr_virt;
 	dma_addr_t		addr_phys;
@@ -82,7 +82,7 @@ struct netup_i2c {
 	wait_queue_head_t		wq;
 	struct i2c_adapter		adap;
 	struct netup_unidvb_dev		*dev;
-	struct netup_i2c_regs		*regs;
+	struct netup_i2c_regs __iomem	*regs;
 	struct i2c_msg			*msg;
 	enum netup_i2c_state		state;
 	u32				xmit_size;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
index 751b51b03593..0bfb14c9e527 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
@@ -226,7 +226,7 @@ int netup_unidvb_ci_register(struct netup_unidvb_dev *dev,
 			__func__, result);
 		return result;
 	}
-	writew(NETUP_UNIDVB_IRQ_CI, (u16 *)(dev->bmmio0 + REG_IMASK_SET));
+	writew(NETUP_UNIDVB_IRQ_CI, dev->bmmio0 + REG_IMASK_SET);
 	dev_info(&pci_dev->dev,
 		"%s(): CI adapter %d init done\n", __func__, num);
 	return 0;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index b012aa658a54..04c8411ea27d 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -190,12 +190,10 @@ static void netup_unidvb_dma_enable(struct netup_dma *dma, int enable)
 		"%s(): DMA%d enable %d\n", __func__, dma->num, enable);
 	if (enable) {
 		writel(BIT_DMA_RUN, &dma->regs->ctrlstat_set);
-		writew(irq_mask,
-			(u16 *)(dma->ndev->bmmio0 + REG_IMASK_SET));
+		writew(irq_mask, dma->ndev->bmmio0 + REG_IMASK_SET);
 	} else {
 		writel(BIT_DMA_RUN, &dma->regs->ctrlstat_clear);
-		writew(irq_mask,
-			(u16 *)(dma->ndev->bmmio0 + REG_IMASK_CLEAR));
+		writew(irq_mask, dma->ndev->bmmio0 + REG_IMASK_CLEAR);
 	}
 }
 
@@ -525,7 +523,7 @@ static int netup_unidvb_ring_copy(struct netup_dma *dma,
 		ring_bytes = dma->ring_buffer_size - dma->data_offset;
 		copy_bytes = (ring_bytes > buff_bytes) ?
 			buff_bytes : ring_bytes;
-		memcpy_fromio(p, dma->addr_virt + dma->data_offset, copy_bytes);
+		memcpy_fromio(p, (u8 __iomem *)(dma->addr_virt + dma->data_offset), copy_bytes);
 		p += copy_bytes;
 		buf->size += copy_bytes;
 		buff_bytes -= copy_bytes;
@@ -538,7 +536,7 @@ static int netup_unidvb_ring_copy(struct netup_dma *dma,
 		ring_bytes = dma->data_size;
 		copy_bytes = (ring_bytes > buff_bytes) ?
 				buff_bytes : ring_bytes;
-		memcpy_fromio(p, dma->addr_virt + dma->data_offset, copy_bytes);
+		memcpy_fromio(p, (u8 __iomem *)(dma->addr_virt + dma->data_offset), copy_bytes);
 		buf->size += copy_bytes;
 		dma->data_size -= copy_bytes;
 		dma->data_offset += copy_bytes;
@@ -644,10 +642,10 @@ static int netup_unidvb_dma_init(struct netup_unidvb_dev *ndev, int num)
 		__func__, num, dma->addr_virt,
 		(unsigned long long)dma->addr_phys,
 		dma->ring_buffer_size);
-	memset_io(dma->addr_virt, 0, dma->ring_buffer_size);
+	memset_io((u8 __iomem *)dma->addr_virt, 0, dma->ring_buffer_size);
 	dma->addr_last = dma->addr_phys;
 	dma->high_addr = (u32)(dma->addr_phys & 0xC0000000);
-	dma->regs = (struct netup_dma_regs *)(num == 0 ?
+	dma->regs = (struct netup_dma_regs __iomem *)(num == 0 ?
 		ndev->bmmio0 + NETUP_DMA0_ADDR :
 		ndev->bmmio0 + NETUP_DMA1_ADDR);
 	writel((NETUP_DMA_BLOCKS_COUNT << 24) |
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
index eaaa2d0a5fba..c09c52bc6eab 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
@@ -320,7 +320,7 @@ static int netup_i2c_init(struct netup_unidvb_dev *ndev, int bus_num)
 	i2c = &ndev->i2c[bus_num];
 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wq);
-	i2c->regs = (struct netup_i2c_regs *)(ndev->bmmio0 +
+	i2c->regs = (struct netup_i2c_regs __iomem *)(ndev->bmmio0 +
 		(bus_num == 0 ? NETUP_I2C_BUS0_ADDR : NETUP_I2C_BUS1_ADDR));
 	netup_i2c_reset(i2c);
 	i2c->adap = netup_i2c_adapter;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
index f55b3276f28d..d659f5974504 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
@@ -45,7 +45,7 @@ struct netup_spi_regs {
 struct netup_spi {
 	struct device			*dev;
 	struct spi_master		*master;
-	struct netup_spi_regs		*regs;
+	struct netup_spi_regs __iomem	*regs;
 	u8 __iomem			*mmio;
 	spinlock_t			lock;
 	wait_queue_head_t		waitq;
@@ -202,7 +202,7 @@ int netup_spi_init(struct netup_unidvb_dev *ndev)
 	spin_lock_init(&nspi->lock);
 	init_waitqueue_head(&nspi->waitq);
 	nspi->master = master;
-	nspi->regs = (struct netup_spi_regs *)(ndev->bmmio0 + 0x4000);
+	nspi->regs = (struct netup_spi_regs __iomem *)(ndev->bmmio0 + 0x4000);
 	writew(2, &nspi->regs->clock_divider);
 	writew(NETUP_UNIDVB_IRQ_SPI, ndev->bmmio0 + REG_IMASK_SET);
 	ndev->spi = nspi;
-- 
2.4.3



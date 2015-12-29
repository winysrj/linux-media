Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2on0109.outbound.protection.outlook.com ([65.55.169.109]:11233
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbbL2ItT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 03:49:19 -0500
From: Chen Bough <Haibo.Chen@freescale.com>
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Bug] compile error
Date: Tue, 29 Dec 2015 08:33:22 +0000
Message-ID: <BY1PR03MB13883543CA9F977B593595019AFC0@BY1PR03MB1388.namprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
For the latest linux-next tree[tag: v4.4-rc6], I meet one compile error, 

drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
drivers/media/usb/uvc/uvc_driver.c:1941:32: error: 'struct uvc_device' has no member named 'mdev'
  if (media_device_register(&dev->mdev) < 0)
                                ^
make[4]: *** [drivers/media/usb/uvc/uvc_driver.o] Error 1
make[4]: *** Waiting for unfinished jobs....



Best Regards
Haibo Chen



Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A344C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3167F21473
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Mm5HVHoR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfA3NqH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:46:07 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:64650 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfA3NqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 08:46:07 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2019 08:46:06 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=769; q=dns/txt; s=iport;
  t=1548855966; x=1550065566;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ESfLAH27jtzbhGTV7tXyBAdHmjaDq+RCBv7p4Q7KTws=;
  b=Mm5HVHoRjh4Co/EubBGSOm0gfKYHHSdwC+cxDBhopn6XKlx8BZrtrWPr
   D3m0zzpp2UVvQr8vV8qoJFe0htgtkc5wh91rnA9QQvDTLm7HM0qQUn4e2
   mIIKLKLkjEhE79UM+QCMwkDpqfOtDR98MLHKhivjSZKeQy5IgvI3k/2T0
   Q=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AEAACEp1Fc/5FdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUQUBAQEBCwGCA4FqJwqME6EFhQ6BewsBAYd0IjQJDQEDAQE?=
 =?us-ascii?q?CAQECbSiFeBNRAT5CJwQTCIUcrAozijiMQBeBQD+PBAKiWAkCkiggkjIBLZs?=
 =?us-ascii?q?OAhEUgScfOIFWcBWDJ5BcQTGPEIEfAQE?=
X-IronPort-AV: E=Sophos;i="5.56,540,1539648000"; 
   d="scan'208";a="232904513"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 13:36:35 +0000
Received: from XCH-ALN-013.cisco.com (xch-aln-013.cisco.com [173.36.7.23])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id x0UDaZnb022629
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 13:36:35 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-013.cisco.com
 (173.36.7.23) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 30 Jan
 2019 07:36:35 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Wed, 30 Jan 2019 07:36:34 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vim2m: fill in bus_info in media_device_info
Thread-Topic: [PATCH] vim2m: fill in bus_info in media_device_info
Thread-Index: AQHUuKDRnGUs4rD7+kSM6/lg0VKidg==
Date:   Wed, 30 Jan 2019 13:36:34 +0000
Message-ID: <4cc870bd01f340cba7224579a3a6be94@XCH-ALN-012.cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.47.79.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.23, xch-aln-013.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is good practice to fill in the bus_info.=0A=
=0A=
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>=0A=
---=0A=
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.=
c=0A=
index 0e7814b2327e..4055aabf2a5e 100644=0A=
--- a/drivers/media/platform/vim2m.c=0A=
+++ b/drivers/media/platform/vim2m.c=0A=
@@ -1155,6 +1155,7 @@ static int vim2m_probe(struct platform_device *pdev)=
=0A=
 #ifdef CONFIG_MEDIA_CONTROLLER=0A=
 	dev->mdev.dev =3D &pdev->dev;=0A=
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));=0A=
+	strscpy(dev->mdev.bus_info, "platform:vim2m", sizeof(dev->mdev.bus_info))=
;=0A=
 	media_device_init(&dev->mdev);=0A=
 	dev->mdev.ops =3D &m2m_media_ops;=0A=
 	dev->v4l2_dev.mdev =3D &dev->mdev;=0A=

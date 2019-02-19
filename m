Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BBFC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA1322147A
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfBSQM7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:12:59 -0500
Received: from mail-out-2.itc.rwth-aachen.de ([134.130.5.47]:38927 "EHLO
        mail-out-2.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbfBSQM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:12:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AZCQB3Kmxc/5wagoZjHQEBHwUBBgGBT?=
 =?us-ascii?q?oEvU1YRgQMxmAKcIwwBIwmILSI4EgEDAQECAQECbRwMhlwBKRoaASInBAGDM4F?=
 =?us-ascii?q?yAQMLrlGELwGFeQWMRIFYPo5iIgKRFZI0BwKBIYYbizaBYQGIeIgqh1qCa4VLj?=
 =?us-ascii?q?DMCAgICCQIUgV0hgVZNJIM8glGITIU/QYFZixwBgR4BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AZCQB3Kmxc/5wagoZjHQEBHwUBBgGBToEvU1YRgQMxmAK?=
 =?us-ascii?q?cIwwBIwmILSI4EgEDAQECAQECbRwMhlwBKRoaASInBAGDM4FyAQMLrlGELwGFe?=
 =?us-ascii?q?QWMRIFYPo5iIgKRFZI0BwKBIYYbizaBYQGIeIgqh1qCa4VLjDMCAgICCQIUgV0?=
 =?us-ascii?q?hgVZNJIM8glGITIU/QYFZixwBgR4BAQ?=
X-IronPort-AV: E=Sophos;i="5.58,388,1544482800"; 
   d="scan'208";a="70438198"
Received: from rwthex-w1-a.rwth-ad.de ([134.130.26.156])
  by mail-in-2.itc.rwth-aachen.de with ESMTP; 19 Feb 2019 17:12:57 +0100
Received: from rwthex-w2-a.rwth-ad.de (2a00:8a60:1:e500::26:158) by
 rwthex-w1-a.rwth-ad.de (2a00:8a60:1:e500::26:156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 19 Feb 2019 17:12:56 +0100
Received: from rwthex-w2-a.rwth-ad.de ([fe80::18f3:313d:3e:42ff]) by
 rwthex-w2-a.rwth-ad.de ([fe80::18f3:313d:3e:42ff%21]) with mapi id
 15.01.1531.010; Tue, 19 Feb 2019 17:12:56 +0100
From:   =?iso-8859-1?Q?Br=FCns=2C_Stefan?= <Stefan.Bruens@rwth-aachen.de>
To:     "moeses@freenet.de" <moeses@freenet.de>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: sysfs: cannot create duplicate filename
 '/devices/pci0000:00/0000:00:14.0/usb1/1-3/dvb/dvb0.frontend0'
Thread-Topic: sysfs: cannot create duplicate filename
 '/devices/pci0000:00/0000:00:14.0/usb1/1-3/dvb/dvb0.frontend0'
Thread-Index: AQHUyG35BVyr2nwFb0GHefEdiUFxUg==
Date:   Tue, 19 Feb 2019 16:12:56 +0000
Message-ID: <5161295.7urLmW147y@sbruens-linux.lcs.intern>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [78.35.13.203]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FDA301E413D53A4097821C246BBF6DA2@rwth-ad.de>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frank,

this is likely the same problem as the one covered here:
https://patchwork.linuxtv.org/patch/54044/

The CT2-4400 uses the dvbsky_t330_props.

Kind regards,

Stefan

Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12B4C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 07:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DD0321917
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 07:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="OqMaUH5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfBHHon (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:44:43 -0500
Received: from mail-eopbgr820058.outbound.protection.outlook.com ([40.107.82.58]:37206
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbfBHHon (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 02:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EU8b+YJOcUJ3yjGU7hLa798Nnn071Oz+wZPZf+xZew=;
 b=OqMaUH5/vPO7JPnZuw+AEMeCrd0gxnhhi0ZzZMcI1/D5DHV+vCxpnGzrl+do1JEL7u1rJKsyBJmAYHKzTVIHAqPen6KuSefQ6GOoc09aOpwJ91HswrsO2E1/Vf+/UQ+RRZibz5hdJNcWhJsY+Lw2AMjLP3emnTIvqaHoCHXxmoU=
Received: from BYAPR05MB5592.namprd05.prod.outlook.com (20.177.186.153) by
 BYAPR05MB5688.namprd05.prod.outlook.com (20.178.1.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.11; Fri, 8 Feb 2019 07:44:37 +0000
Received: from BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::112f:787b:1a2c:cd65]) by BYAPR05MB5592.namprd05.prod.outlook.com
 ([fe80::112f:787b:1a2c:cd65%4]) with mapi id 15.20.1601.016; Fri, 8 Feb 2019
 07:44:37 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Christian.Koenig@amd.com" <Christian.Koenig@amd.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "jgg@mellanox.com" <jgg@mellanox.com>, "hch@lst.de" <hch@lst.de>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "daniel@fooishbar.org" <daniel@fooishbar.org>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUvzQ5rNYocWvZOkiWAVOxemV5ZqXVhd2A
Date:   Fri, 8 Feb 2019 07:44:36 +0000
Message-ID: <97c4d30915593e8a81cb6cd5f44dc09c9fc1343c.camel@vmware.com>
References: <20190207222647.GA30974@ziepe.ca>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-originating-ip: [155.4.205.56]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5688;20:+p6cu1hb1kmhquGsh5g8BXBcFTe+5196c+Cy4/0LVkejRICnne58ovLxcRCqNmjUjVC+Ru+bKKs7UNiIYCXyZZWDwhK3ZS4MvOAZnKMAYe5DfVKqWZj0hP7vRYlZCsm0RghAg4xjE512Sm0SZkIcHeTQ6WVrx7wX5k/1nlMTPgc=
x-ms-office365-filtering-correlation-id: 715d2042-2ced-4433-d8ba-08d68d99466b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5688;
x-ms-traffictypediagnostic: BYAPR05MB5688:
x-microsoft-antispam-prvs: <BYAPR05MB56885F7CD55C4F4BB0181899A1690@BYAPR05MB5688.namprd05.prod.outlook.com>
x-forefront-prvs: 094213BFEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(136003)(39860400002)(396003)(189003)(199004)(97736004)(81166006)(36756003)(6486002)(8936002)(68736007)(8676002)(2501003)(81156014)(86362001)(2201001)(105586002)(118296001)(6436002)(229853002)(7736002)(106356001)(71190400001)(305945005)(71200400001)(110136005)(53936002)(316002)(2616005)(102836004)(6246003)(99286004)(25786009)(7416002)(11346002)(446003)(76176011)(6506007)(486006)(186003)(26005)(476003)(6512007)(6116002)(256004)(4744005)(66066001)(3846002)(14454004)(478600001)(2906002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5688;H:BYAPR05MB5592.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hF1zaBY+eo0/N8anEwN+hQyETzkAACFbF8rIBFXZ+p17+4hQ+jr+fJwJQuYFMeuxYnTlwzVOPyhumcRmrIqNgP22cDA2aTbtJRXG6MeU+vMqI8EI12YRy3EcoyE31TIIsC419eNL1+XqcheBt2kngTB69ETkkbrrxCm6ER3bv/pZXlsW061AcowPruk4yWUd1SV5MrjaXrNUHJ81E51dHZdMNQmfqRQ++sTH2HU7tvQJBuxJg6tcy3dFdUbo8FKjW9nlFIo6eZL3kar9DQ2mFNVXZo6lZRNkIwUnEQhixCJmkfazevs+klMDU7vVlvpyZTqJT2o00ptyhf3+FCZySjxmf8frEwdjbdLMQAApveiTJgu2nR0vLrxi3xYPTqgF8Y1dseW6kK6ujdL7HlCvspl6t9zE78ueJgOfRcWBNn8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A60ACE48A04D644AEDC311EDC845E29@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715d2042-2ced-4433-d8ba-08d68d99466b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2019 07:44:36.8908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5688
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

T24gVGh1LCAyMDE5LTAyLTA3IGF0IDIyOjI2ICswMDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IENvbW1pdCAyZGI3NmQ3YzNjNmQgKCJsaWIvc2NhdHRlcmxpc3Q6IHNnX3BhZ2VfaXRlcjog
c3VwcG9ydCBzZyBsaXN0cw0KPiB3L28NCj4gYmFja2luZyBwYWdlcyIpIGludHJvZHVjZWQgdGhl
IHNnX3BhZ2VfaXRlcl9kbWFfYWRkcmVzcygpIGZ1bmN0aW9uDQo+IHdpdGhvdXQNCj4gcHJvdmlk
aW5nIGEgd2F5IHRvIHVzZSBpdCBpbiB0aGUgZ2VuZXJhbCBjYXNlLiBJZiB0aGUgc2dfZG1hX2xl
bigpIGlzDQo+IG5vdA0KPiBlcXVhbCB0byB0aGUgc2cgbGVuZ3RoIGNhbGxlcnMgY2Fubm90IHNh
ZmVseSB1c2UgdGhlDQo+IGZvcl9lYWNoX3NnX3BhZ2Uvc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNz
IGNvbWJpbmF0aW9uLg0KPiANCj4gUmVzb2x2ZSB0aGlzIEFQSSBtaXN0YWtlIGJ5IHByb3ZpZGlu
ZyBhIERNQSBzcGVjaWZpYyBpdGVyYXRvciwNCj4gZm9yX2VhY2hfc2dfZG1hX3BhZ2UoKSwgdGhh
dCB1c2VzIHRoZSByaWdodCBsZW5ndGggc28NCj4gc2dfcGFnZV9pdGVyX2RtYV9hZGRyZXNzKCkg
d29ya3MgYXMgZXhwZWN0ZWQgd2l0aCBhbGwgc2dsaXN0cy4NCj4gDQo+IEEgbmV3IGl0ZXJhdG9y
IHR5cGUgaXMgaW50cm9kdWNlZCB0byBwcm92aWRlIGNvbXBpbGUtdGltZSBzYWZldHkNCj4gYWdh
aW5zdA0KPiB3cm9uZ2x5IG1peGluZyBhY2Nlc3NvcnMgYW5kIGl0ZXJhdG9ycy4NCj4gDQo+IEFj
a2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4gKGZvciBzY2F0dGVybGlzdCkN
Cj4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPg0KPiAN
Cg0KRm9yIHRoZSB2bXdnZnggcGFydCwgDQpBY2tlZC1ieTogVGhvbWFzIEhlbGxzdHJvbSA8dGhl
bGxzdHJvbUB2bXdhcmUuY29tPg0KDQpJJ2xsIHRha2UgYSBkZWVwZXIgbG9vayB0byBwcm92aWRl
IGEgdm13Z2Z4IGZpeCBhcyBhIGZvbGxvdyB1cC4NCg0KVGhhbmtzLA0KVGhvbWFzDQoNCg==

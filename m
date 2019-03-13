Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DA5C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 07:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 222262184C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 07:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="VwCEZ+3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfCMHZS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:25:18 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:64306 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfCMHZR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 03:25:17 -0400
X-IronPort-AV: E=Sophos;i="5.58,474,1544511600"; 
   d="scan'208";a="28080025"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Mar 2019 00:25:15 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 13 Mar 2019 00:25:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sc6FHkGWhzhYEp+frnM25+v4g0xyLU39GFofYDKDvDQ=;
 b=VwCEZ+3I4urcTZ8YBXR3NALy6ySPJjadKHUfXOBsOnBzrl3l+rd9Kv0LUNbkx6YBeOoT3E1Md+eREsttXM+ZOb81PKF1BeBayEEtbNDqmhoAazsTBQOhMFrJa1kUSEywF29JFnV5+zpNHPbzih1IEpOo82xm5vvj75kXc0qcVRc=
Received: from DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) by
 DM5PR11MB1436.namprd11.prod.outlook.com (10.172.36.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.19; Wed, 13 Mar 2019 07:25:11 +0000
Received: from DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8]) by DM5PR11MB1242.namprd11.prod.outlook.com
 ([fe80::e8b6:2ae9:9b9c:2ca8%3]) with mapi id 15.20.1709.011; Wed, 13 Mar 2019
 07:25:11 +0000
From:   <Eugen.Hristev@microchip.com>
To:     <hverkuil@xs4all.nl>, <Nicolas.Ferre@microchip.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <mchehab@kernel.org>
CC:     <ksloat@aampglobal.com>, <Eugen.Hristev@microchip.com>
Subject: [PATCH v2 2/2] media: atmel: atmel-isc: removed ARGB32 added ABGR32
 and XBGR32
Thread-Topic: [PATCH v2 2/2] media: atmel: atmel-isc: removed ARGB32 added
 ABGR32 and XBGR32
Thread-Index: AQHU2W3lU7opBCn6EkGZZ3srpDIfQQ==
Date:   Wed, 13 Mar 2019 07:25:11 +0000
Message-ID: <1552461639-8708-2-git-send-email-eugen.hristev@microchip.com>
References: <1552461639-8708-1-git-send-email-eugen.hristev@microchip.com>
In-Reply-To: <1552461639-8708-1-git-send-email-eugen.hristev@microchip.com>
Accept-Language: ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0147.eurprd07.prod.outlook.com
 (2603:10a6:802:16::34) To DM5PR11MB1242.namprd11.prod.outlook.com
 (2603:10b6:3:14::8)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Eugen.Hristev@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c8a0510-8cf0-43cc-9437-08d6a7850728
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DM5PR11MB1436;
x-ms-traffictypediagnostic: DM5PR11MB1436:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;DM5PR11MB1436;23:DppEESQmZ6k82HF8q3V6wguO7qc60xdSK8K6eCE?=
 =?iso-8859-1?Q?B2hfw1Rl5rssfCCcPhu80FtVM2n4V7KVRdqn7SjOKnQu4LmaqMXSm0+spE?=
 =?iso-8859-1?Q?H5z4dGOi0MUyHLCb1vdmYtQ8viPgRVhSkMdLynI4oLEQX/8d0r1b2PzO7a?=
 =?iso-8859-1?Q?uC67lERtLtgaj2yG3/WR2h3YzzWygXFg62O+KAvCmh2iVL2Y4HVQh9Ssal?=
 =?iso-8859-1?Q?Bu+9H99c8gP6KlgZpKCq5WY7B+UtaWF8sEdQ7kT1Ai7WmlVUMZfw6alXb4?=
 =?iso-8859-1?Q?sBeBdDXUknHQ+Qn4dF6zinzroxNQHM77womT1BZqSxVfxGhB+jXE4K4hfU?=
 =?iso-8859-1?Q?8+rHD90i4M72VczJIIwJkVv5jtvMVbdcbTPLwjiAkwG327akEehaqDLyY8?=
 =?iso-8859-1?Q?zIhAqOqJgr+6Re2qU3ab2bUp0Fus/oG9eQdBUSlxKq5SyEDMkxjDSrjUf3?=
 =?iso-8859-1?Q?8loFRxSDZcLDB1fa13dgiZvjJcK4y8F4DfB0+HOQ3Y6kInA2i3M8vI/rRA?=
 =?iso-8859-1?Q?+/ScyiIqFR+Q+oUdJ17Hz0TLSnIvSXKx5ieVhaq4lgI+2OMMWkfN5Q0pwp?=
 =?iso-8859-1?Q?CYi0KpdS0UjriDsxBhg62Ubh4lePyoUoOffgYiDBJ6PMhzTmqbUZeGWlwx?=
 =?iso-8859-1?Q?wHrzIzuoFSoH4XQsgHWnsiZeU1txDQbsyxVrFiiay4NGYOIBfHpU56QxeL?=
 =?iso-8859-1?Q?MlYJ4J7TVRXsXRJgAQHK6FVsgVeNLNH1EpGPnrIukpn4vHSa4EWJLRzxjR?=
 =?iso-8859-1?Q?0AN/VvOMnJbE95XtKoKun8v2RN4vM5SWPkDouHFLUyGfvhzEcPF8I9HUK3?=
 =?iso-8859-1?Q?ZUVlYSNPTRjxKIBF33w67zwhA4n9XkapYyWhSMa5dUsyX6qw2ZTn5cQSLe?=
 =?iso-8859-1?Q?UW07aGooHTGnGgYRhl0RqUm+HK/uJuTX5F2ZKDaQ71Yzp/ZEwsMv/mvr1J?=
 =?iso-8859-1?Q?uLnsnmA5VVXemmXVO082mGr4S5jL+7saoxwakgY4pqicD3Au2vXI4XltcR?=
 =?iso-8859-1?Q?WIgxAyWaUWlnvqwTur6GbIEKo7+aauoUHZPD2ESxCgqR8lYpGJpqIIb4ew?=
 =?iso-8859-1?Q?QrJdQnu806K4ulKg0GuI1Ccx3haU+cqtli10OUEfkfToXJs29QgR/yXFAO?=
 =?iso-8859-1?Q?oaLGLCRzoVQf+gu7L4dZQzZnsCf0f0n0kmtjrrqlL3sP7J1kL4J9wax4dH?=
 =?iso-8859-1?Q?2ejMsxwFZxMitOH16qVSjESuCUs6SBjGPILJgGeWtuCh/j+pva99zvVaPl?=
 =?iso-8859-1?Q?vfsR/90m0dUyaCGqgKUPYqOK70VZRrNuZZ2ZwwLZKhWzlkntRjbnNKUwem?=
 =?iso-8859-1?Q?SfOeX/Qr/SlcVScGJzKFKxLPZQuTbwg3L+CCL+aRyeftuslDl1PXHvREic?=
 =?iso-8859-1?Q?IpAc4fO64XiDwCYoutjt0uCUr6S3m/HoS9y4V0vZOx/Qh7APTfQ=3D=3D?=
x-microsoft-antispam-prvs: <DM5PR11MB1436500F94AE8B9BDE7070A6E84A0@DM5PR11MB1436.namprd11.prod.outlook.com>
x-forefront-prvs: 09752BC779
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(3846002)(5660300002)(6116002)(53936002)(36756003)(50226002)(2201001)(8936002)(86362001)(110136005)(8676002)(4326008)(6436002)(68736007)(107886003)(6512007)(53946003)(6486002)(6506007)(81166006)(81156014)(386003)(316002)(30864003)(76176011)(54906003)(14444005)(66066001)(256004)(186003)(102836004)(26005)(25786009)(305945005)(52116002)(7736002)(11346002)(99286004)(478600001)(446003)(97736004)(72206003)(2616005)(476003)(486006)(2906002)(71200400001)(14454004)(105586002)(71190400001)(106356001)(2501003)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1436;H:DM5PR11MB1242.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zerqPJwhHWdcZB6fhtxI2oQ0lMPPYy/WjMVRTfXUfsWyuC0CGGIVaLaVJhVCaIJqIfZC00lQKTM4B8zaw5dbLDvmLUJjGtVn568nGbvbyNo+Jv8jTvA+2qguiuI8NF0L2SdAfoOI7/LeQh4S9jFMvwe9Ok6NK64tY7pqA4RDCs81HJ5ii6O6I3TAdZqbRObO1VKPcQW76xuGRtdj84HZUR5VLwO8OIldm4qNzGJW20NMzpQTaX+yWeP5ofYdApl9d+IDvpBT3GIBOliaHQYvihBCvefaQfvem357LlQuLf0mGxCQqZVVRFZbPDlzN14dldspbooi+zb4kBfRREY/Ma+AkVMP926PdxwPBv1f9u5M8KcJydbpmpt5yiQyupL16cCJZu9kkqdK3jtMB/dUS6kZ1XdlLQbWBS8UwSXvgf4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8a0510-8cf0-43cc-9437-08d6a7850728
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2019 07:25:11.7807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1436
X-OriginatorOrg: microchip.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

ISC will output the "ARGB32" configuration in byte order: B, G, R, Alpha.
This is in fact the format BGRA, aka ABGR32.
If alpha is missing, the same format is equivalent to XBGR32.
Added both formats and removed ARGB32 which is wrong.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
---

with ov5640:


~# v4l2-ctl --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture

        [0]: 'AR12' (16-bit ARGB 4-4-4-4)
        [1]: 'AR15' (16-bit ARGB 1-5-5-5)
        [2]: 'RGBP' (16-bit RGB 5-6-5)
        [3]: 'AR24' (32-bit BGRA 8-8-8-8)
        [4]: 'XR24' (32-bit BGRX 8-8-8-8)
        [5]: 'YU12' (Planar YUV 4:2:0)
        [6]: 'YUYV' (YUYV 4:2:2)
        [7]: '422P' (Planar YUV 4:2:2)
        [8]: 'GREY' (8-bit Greyscale)
        [9]: 'BA81' (8-bit Bayer BGBG/GRGR)
        [10]: 'GBRG' (8-bit Bayer GBGB/RGRG)
        [11]: 'GRBG' (8-bit Bayer GRGR/BGBG)
        [12]: 'RGGB' (8-bit Bayer RGRG/GBGB)



~# v4l2-ctl --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture

        [0]: 'AR12' (16-bit ARGB 4-4-4-4)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [1]: 'AR15' (16-bit ARGB 1-5-5-5)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [2]: 'RGBP' (16-bit RGB 5-6-5)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [3]: 'AR24' (32-bit BGRA 8-8-8-8)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [4]: 'XR24' (32-bit BGRX 8-8-8-8)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [5]: 'YU12' (Planar YUV 4:2:0)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [6]: 'YUYV' (YUYV 4:2:2)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [7]: '422P' (Planar YUV 4:2:2)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [8]: 'GREY' (8-bit Greyscale)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [9]: 'BA81' (8-bit Bayer BGBG/GRGR)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [10]: 'GBRG' (8-bit Bayer GBGB/RGRG)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [11]: 'GRBG' (8-bit Bayer GRGR/BGBG)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
        [12]: 'RGGB' (8-bit Bayer RGRG/GBGB)
                Size: Discrete 176x144
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                        Interval: Discrete 0.017s (60.000 fps)
                Size: Discrete 720x480
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 720x576
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1920x1080
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 2592x1944
                        Interval: Discrete 0.067s (15.000 fps)
                        Interval: Discrete 0.033s (30.000 fps)


 drivers/media/platform/atmel/atmel-isc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platf=
orm/atmel/atmel-isc.c
index f4ecb24..5d153a9 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -228,7 +228,10 @@ static struct isc_format controller_formats[] =3D {
 		.fourcc		=3D V4L2_PIX_FMT_RGB565,
 	},
 	{
-		.fourcc		=3D V4L2_PIX_FMT_ARGB32,
+		.fourcc		=3D V4L2_PIX_FMT_ABGR32,
+	},
+	{
+		.fourcc		=3D V4L2_PIX_FMT_XBGR32,
 	},
 	{
 		.fourcc		=3D V4L2_PIX_FMT_YUV420,
@@ -1099,7 +1102,8 @@ static int isc_try_validate_formats(struct isc_device=
 *isc)
 		break;
=20
 	case V4L2_PIX_FMT_RGB565:
-	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ARGB444:
 	case V4L2_PIX_FMT_ARGB555:
 		ret =3D 0;
@@ -1183,7 +1187,8 @@ static int isc_try_configure_rlp_dma(struct isc_devic=
e *isc, bool direct_dump)
 		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
 		isc->try_config.bpp =3D 16;
 		break;
-	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_XBGR32:
 		isc->try_config.rlp_cfg_mode =3D ISC_RLP_CFG_MODE_ARGB32;
 		isc->try_config.dcfg_imode =3D ISC_DCFG_IMODE_PACKED32;
 		isc->try_config.dctrl_dview =3D ISC_DCTRL_DVIEW_PACKED;
@@ -1229,7 +1234,8 @@ static int isc_try_configure_pipeline(struct isc_devi=
ce *isc)
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_ARGB555:
 	case V4L2_PIX_FMT_ARGB444:
-	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_XBGR32:
 		/* if sensor format is RAW, we convert inside ISC */
 		if (ISC_IS_FORMAT_RAW(isc->try_config.sd_format->mbus_code)) {
 			isc->try_config.bits_pipeline =3D CFA_ENABLE |
--=20
2.7.4


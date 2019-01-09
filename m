Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LOCALPART_IN_SUBJECT,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B09CC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8CD20661
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="DhM8xGe3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbfAIAf6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:35:58 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16745 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfAIAf6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:35:58 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5c3541db0000>; Tue, 08 Jan 2019 16:35:39 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Jan 2019 16:35:56 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Jan 2019 16:35:56 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 9 Jan
 2019 00:35:55 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4 via Frontend Transport; Wed, 9 Jan 2019 00:35:55 +0000
Received: from SN6PR12MB2813.namprd12.prod.outlook.com (52.135.100.27) by
 SN6PR12MB2781.namprd12.prod.outlook.com (52.135.107.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Wed, 9 Jan 2019 00:35:54 +0000
Received: from SN6PR12MB2813.namprd12.prod.outlook.com
 ([fe80::3c0b:d7cf:db30:5ff5]) by SN6PR12MB2813.namprd12.prod.outlook.com
 ([fe80::3c0b:d7cf:db30:5ff5%2]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 00:35:54 +0000
From:   Bhanu Murthy V <bmurthyv@nvidia.com>
To:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: unsubscribe linux-media
Thread-Topic: unsubscribe linux-media
Thread-Index: AdSnsw4G84j/bjgkSuuW0k3dl8+7RQAACfZA
Date:   Wed, 9 Jan 2019 00:35:54 +0000
Message-ID: <SN6PR12MB2813CB952B0F063DBC057528B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
References: <SN6PR12MB28138BF9EDDB2256E2889B68B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB28138BF9EDDB2256E2889B68B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=bmurthyv@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2019-01-09T00:34:22.3180838Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic;
 Sensitivity=Unrestricted
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bmurthyv@nvidia.com; 
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR12MB2781;6:mACbG5+wPwPQIl8pX1FvdJ6M88kGHosugmW76d9/vKGvXorFQxoh/PI8Shv57PbgDnJ+YQhchKmhmDx/5oLDj52+fWh9C31gjHvs782wxJKKDHvFikkSSq7ryJ47Y6QUT36KgCrgFthM2BEdXk6wsOhVVK7QV29ayR+A6SjBS0QnwL0xC2vcU5p0uwOofqMcfwFVnV+jL0lwtEZdIlSfYqvnwrpWUXYYdKk7cVokG9prDDLGw/nqa35SWJdtKsk4jGGfRyW1Q5EqIDXUZbpc6zRYVf+PUe+QF8y38OOfKTYvxJCkwlq0JEvW7BQt2peOkFA/+umeFnX+zyIba0Z6fWyqmaJPkhHhUToS1W3jJlnAkNibICKxkKvL9AOCkQYCZcOBu4v8J5hM1kVSs6nLgkVQNkPwpOEzE3uCzvEwtoQwZViQFChieg5zZgB04MJlL1zMm4o0En2KqH0CG3PfIA==;5:LnLzTQoQ9W+7ROK5P0oss7N0iBa4txot7XADgG2iL7E8La9h+ThEfUhdjvM994QkRsC+YQFD2evY6hsoF6iOTeWXzER9Gw41jeEw21U3Kvo1i01DrkSmfcwkPFTqZHQVFJaRbZsTPy/kxr5rOFiMezSfyeAeg5ndhwR4QYfCgTpFbL1uAODEVAA2xKfhT0+OQRL/iYC6660fq8Vq8uI5pQ==;7:sE29O8mLnfFoUQwpZrUcQMTzMfRFNB6eWvdEZktBs5QwXwusMsChJei22eYKN5AW6uE9iESuO2ODFBi8vY5Grxj1O4vfZk/xthhR/Wmf1laTTON21AGAkEdGEDTFVaEgJ+95ppPXwa8iY0gGWYq5zw==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: a3a7a812-33fc-425f-151e-08d675ca6a61
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR12MB2781;
x-ms-traffictypediagnostic: SN6PR12MB2781:
x-microsoft-antispam-prvs: <SN6PR12MB278142159E4FA09337E89DEDB38B0@SN6PR12MB2781.namprd12.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(39860400002)(366004)(376002)(189003)(199004)(102836004)(186003)(6506007)(53936002)(26005)(2351001)(7736002)(305945005)(476003)(66066001)(11346002)(446003)(9686003)(19618925003)(8936002)(2906002)(55016002)(6246003)(6916009)(68736007)(74316002)(6116002)(3846002)(25786009)(5660300001)(99286004)(105586002)(106356001)(8676002)(4270600006)(7696005)(316002)(97736004)(558084003)(76176011)(256004)(6436002)(229853002)(5640700003)(2940100002)(86362001)(14454004)(486006)(3480700005)(93156006)(81156014)(71190400001)(71200400001)(81166006)(33656002)(2501003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2781;H:SN6PR12MB2813.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ggwZok3cKqxfmo7ugkcr6efU7UR1R9hAUqLawaHkp06PC5+Mosvpq06ma91t+4t69PoCNP+v/T/b3O0YDVEY8D3nRdzfbuj/eiVPXbb7N0z1uagT9e3YIcE8IznmIer1fS+2O6WZVrWdWdwDUGBIJmAlrmUHHX2fktUnGe830X5MBIY6ZoRtzS77N9oShtwLHlxp5RZk5FkFqM2lHvMwnn+IaC7oXCoDxEpbtEKdsRb1pXg73f3aNmBWhJS2gV7N9QsIM+bo8XT36YJNsNyjCOyJlBCgF/c/XD4Xh4uMlmgzmH/TzCnayQjCBZEjw82U
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a7a812-33fc-425f-151e-08d675ca6a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 00:35:54.7204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2781
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1546994139; bh=BxY0z5eWGPPWISLhEWCbiUD9lLTqSKmOBuQ6BQHsIzM=;
        h=X-PGP-Universal:From:To:Subject:Thread-Topic:Thread-Index:Date:
         Message-ID:References:In-Reply-To:Accept-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:msip_labels:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-microsoft-exchange-diagnostics:
         x-ms-exchange-antispam-srfa-diagnostics:
         x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-forefront-prvs:x-forefront-antispam-report:received-spf:
         x-ms-exchange-senderadcheck:x-microsoft-antispam-message-info:
         spamdiagnosticoutput:spamdiagnosticmetadata:MIME-Version:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=DhM8xGe38HhCQdD5RQPgw3GhFyUmFHbMukyF7qfJpH+VhPWMgQK6OLmwDIKwkyn3P
         rtzm1w7UwDrz+vnz83TG+0iRJE0v2GoRS8bfpL0V2J9Uf9yTYoI3W59ydJsiOR/ADC
         hJgEfnHTYpd7rpoUDdMcdwr+0j66S0O0EMxgJ9GCufhlQLuex5fMSVOjSDHWZRiiCU
         XzqPOlJcyX2TwkWt9c7eTAK+GPlJVIZYlPP0o/XEUgYZAMtZn3r6hAHb0x+uM3r30E
         lBlvCS1KhtCoLRNeRT4q6lZ4Lhu/Cfy4EEU1Y0jH+w3+HrkKbKWBnJIBZ2iiZU4Ug/
         b9RwdCdqiLAFg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

unsubscribe linux-media
-------------------------------------------------------------------------=
----------
This email message is for the sole use of the intended recipient(s) and m=
ay contain
confidential information.  Any unauthorized review, use, disclosure or di=
stribution
is prohibited.  If you are not the intended recipient, please contact the=
=20sender by
reply email and destroy all copies of the original message.
-------------------------------------------------------------------------=
----------

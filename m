Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7A2C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 12:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449B6217D9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 12:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="q+QfhORU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfBRMXo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 07:23:44 -0500
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:9754
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729016AbfBRMXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 07:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2+ibzXgEXe42BO+Blg/LL9RFv6M2f1amN29UaFLelQ=;
 b=q+QfhORUiKxQSNuHAvaGEn3ODJ0gxuw7OMIgSvsdRq1+L0FkFlb2pNk80RFeI9VckOMCh0DyqePTNaK3apMpXi2Y/82ucSrPQEIb4S8OG24AdGSR5zyLWm3YhDIiw+1Z/nrQMa6b6WzQqiOX6QeKY3N+jsjwzpYnFSbVjjaVgkY=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB3556.eurprd08.prod.outlook.com (20.177.110.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Mon, 18 Feb 2019 12:22:58 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::6cf2:41c2:1a33:9b18]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::6cf2:41c2:1a33:9b18%3]) with mapi id 15.20.1622.020; Mon, 18 Feb 2019
 12:22:58 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        nd <nd@arm.com>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Topic: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Index: AQHUx4SuF0wk/rt+2UuytgV1PyNhIQ==
Date:   Mon, 18 Feb 2019 12:22:58 +0000
Message-ID: <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.49]
x-clientproxiedby: LO2P265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::19) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 347abeaf-7376-4ad4-15c9-08d6959bd140
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB3556;
x-ms-traffictypediagnostic: AM0PR08MB3556:
nodisclaimer: True
x-microsoft-exchange-diagnostics: 1;AM0PR08MB3556;20:bZLnVqCtB7NDKzbT5cqd7EfQQksfUsOCHmwB9gtw7ReAlAT+e7swK+84fDctOr+n692vjtmhjJke+gogr+Kt+OG63i9QOk35bCbetkHCw3gCCH1IEu/NE6e4fDgq59B4MRlryOaKvOz98eCPzNjkC7Wj5KHYnNAH+sy5qbmUGz4=
x-microsoft-antispam-prvs: <AM0PR08MB3556BBBE855C370F66A75FCEF0630@AM0PR08MB3556.eurprd08.prod.outlook.com>
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(52116002)(33896004)(6436002)(76176011)(476003)(446003)(11346002)(186003)(72206003)(86362001)(99286004)(26005)(256004)(14454004)(14444005)(97736004)(102836004)(478600001)(386003)(6506007)(6486002)(105586002)(66066001)(6246003)(8676002)(8936002)(229853002)(106356001)(68736007)(53936002)(7736002)(2906002)(81166006)(81156014)(71190400001)(25786009)(305945005)(4326008)(9686003)(71200400001)(486006)(316002)(1076003)(44832011)(58126008)(5660300002)(6512007)(54906003)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB3556;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z0EtUy96tt/Tgzi1Z62GrpaJ6/GGAfr37lLeMaybIiPqfBOEmO3FHy+3ieyYrUKhyDvHv7KjmPRWhUq4QHHLVBw50B6Kq9Q4wRCE1wLB9H/I1p7a2amCZw037iP1nc/WoDzzNa7K6bnDx02NJW753xdvElyUMlahPPam+H0ULo9xy7Hg82f7yfsKA2KS37qaJYXV8oxzLoOmC0ukB5Fy6LDTSFGEadWBO4FumAi+bpw6LyVCEGjI3IAulUGL6zlcCPx5FRYG5Fij/oYrN8q9FbB55b46TX7ILHVewinlUo0J6BVtkt6zdCAE0ec+74OvXfDVurb/8Kc/Zs2dHNjLvjKgpzdpuK7qMIYK04Z89fj17zBCZEZHaviJjAScasmLmOvdoOUUPFZQqBMA5aoat6Mq1aaGOnMfgCZFKdNqqxM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C65B6F3C494074180BD904A4EDFFC60@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347abeaf-7376-4ad4-15c9-08d6959bd140
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 12:22:58.1200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3556
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> Hello,
>=20
> This patch series implements display writeback support for the R-Car
> Gen3 platforms in the VSP1 driver.
>=20
> DRM/KMS provides a writeback API through a special type of writeback
> connectors. This series takes a different approach by exposing writeback
> as a V4L2 device. While there is nothing fundamentally wrong with
> writeback connectors, display for R-Car Gen3 platforms relies on the
> VSP1 driver behind the scene, which already implements V4L2 support.
> Enabling writeback through V4L2 is thus significantly easier in this
> case.

How does this look to an application? (I'm entirely ignorant about
R-Car). They are interacting with the DRM device, and then need to
open and configure a v4l2 device to get the writeback? Can the process
which isn't controlling the DRM device independently capture the
screen output?

I didn't see any major complication to implementing this as a
writeback connector. If you want/need to use the vb2_queue, couldn't
you just do that entirely from within the kernel?

Honestly (predictably?), to me it seems like a bad idea to introduce a
second, non-compatible interface for display writeback. Any
application interested in display writeback (e.g. compositors) will
need to implement both in order to support all HW. drm_hwcomposer
already supports writeback via DRM writeback connectors.

While I can see the advantages of having writeback exposed via v4l2
for streaming use-cases, I think it would be better to have it done in
such a way that it works for all writeback connectors, rather than
being VSP1-specific. That would allow any application to choose
whichever method is most appropriate for their use-case, without
limiting themselves to a subset of hardware.

>=20
> The writeback pixel format is restricted to RGB, due to the VSP1
> outputting RGB to the display and lacking a separate colour space
> conversion unit for writeback. The resolution can be freely picked by
> will result in cropping or composing, not scaling.
>=20
> Writeback requests are queued to the hardware on page flip (atomic
> flush), and complete at the next vblank. This means that a queued
> writeback buffer will not be processed until the next page flip, but
> once it starts being written to by the VSP, it will complete at the next
> vblank regardless of whether another page flip occurs at that time.
>=20

This sounds the same as mali-dp, and so fits directly with the
semantics of writeback connectors.

Thanks,
-Brian

> The code is based on a merge of the media master branch, the drm-next
> branch and the R-Car DT next branch. For convenience patches can be
> found at
>=20
> 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
>=20
> Kieran Bingham (2):
>   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
>   media: vsp1: Provide a writeback video device
>=20
> Laurent Pinchart (5):
>   media: vsp1: wpf: Fix partition configuration for display pipelines
>   media: vsp1: Replace leftover occurrence of fragment with body
>   media: vsp1: Fix addresses of display-related registers for VSP-DL
>   media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
>   media: vsp1: Replace the display list internal flag with a flags field
>=20
>  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
>  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
>  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
>  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
>  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
>  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
>  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
>  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++----
>  drivers/media/platform/vsp1/vsp1_video.h |   6 +
>  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
>  11 files changed, 378 insertions(+), 75 deletions(-)
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart
>=20

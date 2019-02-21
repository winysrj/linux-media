Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7DFC00319
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C48B2148D
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 09:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="Yo0Anx0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfBUJu1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:50:27 -0500
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:43430
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfBUJu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 04:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxS4XHVKy3Gb7UFAF4N17MLldc7FQRWEk6jRWOAYs+A=;
 b=Yo0Anx0zHQtTlEg/nwhy+/J5slHqcVcAY7y6a+FCoSHSo2Wcg4vPrm8338Nna7/qlzHwVpN8mVCNFz1ubNBFv7N6ZJaZ+wm1UB2ZYPZlZDAhT+JpMzLWxqEi0ufX9ShCHzQETdk5qUKXKfXlcmdzcidGdpMX3qlbWGxpR3Sh2ks=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB4594.eurprd08.prod.outlook.com (20.178.83.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Thu, 21 Feb 2019 09:50:19 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd%2]) with mapi id 15.20.1643.016; Thu, 21 Feb 2019
 09:50:19 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Topic: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Index: AQHUx4SuF0wk/rt+2UuytgV1PyNhIaXp7lqAgAAYUYA=
Date:   Thu, 21 Feb 2019 09:50:19 +0000
Message-ID: <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
In-Reply-To: <20190221082317.GB3451@pendragon.ideasonboard.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.51]
x-clientproxiedby: LO2P265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::15) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d51b1d15-c71d-44ee-ddd5-08d697e1fd26
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB4594;
x-ms-traffictypediagnostic: AM0PR08MB4594:
x-ms-exchange-purlcount: 2
nodisclaimer: True
x-microsoft-exchange-diagnostics: 1;AM0PR08MB4594;20:np62aJCRagJEQn3C2cPBKXzqCGgdsWsjR3i4d2ixizi9gaFjDW/c6ZBTdlXzVaR5SU/NriH8GPSYq1d1lAuCntp8Xqi3fyi5kYPHQIsgbOHNpXcU45xW39zTuGyYIsKq1ZLy7+waOy0P+P7wSpIIaus4TXg8cz9lafJazCDKXLg=
x-microsoft-antispam-prvs: <AM0PR08MB45946A26D629231D8149C357F07E0@AM0PR08MB4594.eurprd08.prod.outlook.com>
x-forefront-prvs: 09555FB1AD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(366004)(396003)(346002)(55674003)(189003)(199004)(6246003)(97736004)(25786009)(106356001)(4326008)(66066001)(105586002)(3846002)(26005)(8676002)(6116002)(305945005)(81156014)(186003)(81166006)(14454004)(7736002)(54906003)(6916009)(6512007)(58126008)(316002)(53936002)(8936002)(476003)(11346002)(229853002)(102836004)(72206003)(99286004)(44832011)(9686003)(6306002)(68736007)(478600001)(486006)(446003)(52116002)(6436002)(2906002)(14444005)(966005)(256004)(5660300002)(71200400001)(86362001)(6486002)(71190400001)(76176011)(1076003)(33896004)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4594;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JgqeixPM60XOOI3VKMpG/vKPuf6ondxzmN61UBfRT6pw/vI91lSlhRUv771TLm5o60e7oJEU2HCJALPUU0rR3abHwhasdjXahOD6PLh1Ex2z2DzGpSmW1fWlWwpluylRh3fF9npXQKPR4v9p7MjBb6xauCpcRhha2T8MT7CRUcAE/Od7vY50SmgKzo40r/eUcYkrfU7hnrqMlTvA1/e8eTYxq/kdk7FrBmo/wcgqgLk5GwdRpnx9cNBTpuP1bq0kUcJsOh1SdAKwvoMcleNvZpVVU4twv/tBdGAVJhOH2V6zNDvXqoUvm6L95vqhdlQUoUXQmh/alOjBkV/av/oIeBOO3yhx2uDhrhAJ3CJztNqb9q+mcVBp5g654pQAUEcVA51EiydSDv+v15wK8fcJDgX6bkp+1KdTxtGf1MFY4kg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A79B73B0076CDA4982C3CABEA5427FF4@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51b1d15-c71d-44ee-ddd5-08d697e1fd26
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2019 09:50:18.8491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4594
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Thu, Feb 21, 2019 at 10:23:17AM +0200, Laurent Pinchart wrote:
> Hi Brian,
>=20
> On Mon, Feb 18, 2019 at 12:22:58PM +0000, Brian Starkey wrote:
> > On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> > > Hello,
> > >=20
> > > This patch series implements display writeback support for the R-Car
> > > Gen3 platforms in the VSP1 driver.
> > >=20
> > > DRM/KMS provides a writeback API through a special type of writeback
> > > connectors. This series takes a different approach by exposing writeb=
ack
> > > as a V4L2 device. While there is nothing fundamentally wrong with
> > > writeback connectors, display for R-Car Gen3 platforms relies on the
> > > VSP1 driver behind the scene, which already implements V4L2 support.
> > > Enabling writeback through V4L2 is thus significantly easier in this
> > > case.
> >=20
> > How does this look to an application? (I'm entirely ignorant about
> > R-Car). They are interacting with the DRM device, and then need to
> > open and configure a v4l2 device to get the writeback? Can the process
> > which isn't controlling the DRM device independently capture the
> > screen output?
> >=20
> > I didn't see any major complication to implementing this as a
> > writeback connector. If you want/need to use the vb2_queue, couldn't
> > you just do that entirely from within the kernel?
> >=20
> > Honestly (predictably?), to me it seems like a bad idea to introduce a
> > second, non-compatible interface for display writeback. Any
> > application interested in display writeback (e.g. compositors) will
> > need to implement both in order to support all HW. drm_hwcomposer
> > already supports writeback via DRM writeback connectors.
> >=20
> > While I can see the advantages of having writeback exposed via v4l2
> > for streaming use-cases, I think it would be better to have it done in
> > such a way that it works for all writeback connectors, rather than
> > being VSP1-specific. That would allow any application to choose
> > whichever method is most appropriate for their use-case, without
> > limiting themselves to a subset of hardware.
>=20
> So I gave writeback connectors a go, and it wasn't very pretty.

Sorry you didn't have a good time :-(

> There writeback support in the DRM core leaks jobs,

Is this the cleanup on check fail, or something else?

One possible pitfall is that you must set the job in the connector
state to NULL after you call drm_writeback_queue_job(). The API there
could easily be changed to pass in the connector_state and clear it in
drm_writeback_queue_job() instead of relying on drivers to do it.

> and is missing support for
> the equivalent of .prepare_fb()/.cleanup_fb(), which requires per-job
> driver-specific data. I'm working on these issues and will submit
> patches.
>=20

Hm, yes that didn't occur to me; we don't have a prepare_fb callback.

> In the meantime, I need to test my implementation, so I need a command
> line application that will let me exercise the API. I assume you've
> tested your code, haven't you ? :-) Could you tell me how I can test
> writeback ?

Indeed, there's igts on the list which I wrote and tested:

https://patchwork.kernel.org/patch/10764975/

And there's support in drm_hwcomposer (though I must admit I haven't
personally run the drm_hwc code):

https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer/merge_requests=
/3

I'm afraid I haven't really touched any of the writeback code for a
couple of years - Liviu picked that up. He's on holiday until Monday,
but he should be able to help with the status of the igts.

Hope that helps,

-Brian

>=20
> > > The writeback pixel format is restricted to RGB, due to the VSP1
> > > outputting RGB to the display and lacking a separate colour space
> > > conversion unit for writeback. The resolution can be freely picked by
> > > will result in cropping or composing, not scaling.
> > >=20
> > > Writeback requests are queued to the hardware on page flip (atomic
> > > flush), and complete at the next vblank. This means that a queued
> > > writeback buffer will not be processed until the next page flip, but
> > > once it starts being written to by the VSP, it will complete at the n=
ext
> > > vblank regardless of whether another page flip occurs at that time.
> >=20
> > This sounds the same as mali-dp, and so fits directly with the
> > semantics of writeback connectors.
> >=20
> > > The code is based on a merge of the media master branch, the drm-next
> > > branch and the R-Car DT next branch. For convenience patches can be
> > > found at
> > >=20
> > > 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
> > >=20
> > > Kieran Bingham (2):
> > >   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> > >   media: vsp1: Provide a writeback video device
> > >=20
> > > Laurent Pinchart (5):
> > >   media: vsp1: wpf: Fix partition configuration for display pipelines
> > >   media: vsp1: Replace leftover occurrence of fragment with body
> > >   media: vsp1: Fix addresses of display-related registers for VSP-DL
> > >   media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
> > >   media: vsp1: Replace the display list internal flag with a flags fi=
eld
> > >=20
> > >  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
> > >  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
> > >  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
> > >  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
> > >  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
> > >  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
> > >  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
> > >  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
> > >  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++--=
--
> > >  drivers/media/platform/vsp1/vsp1_video.h |   6 +
> > >  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
> > >  11 files changed, 378 insertions(+), 75 deletions(-)
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart

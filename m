Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C3AC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 12:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AA262084D
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 12:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="hq9GJY4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfBUMTT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:19:19 -0500
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:29328
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfBUMTT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 07:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bVYXM/e3Fdj5N+dmVCh1lTofObp731ZzWAQiwcdXSM=;
 b=hq9GJY4lJSEvs9jkBRcWW6iWppGheyDiaYkSGpLua+lzztek3fcSFuK5Ynt5BZZy0R+PmQ4WRBSSBD9OuiC2E3NDB2wWnivhIwvpHz6ta8SShw6IJ36li7TjujasvnGL14fG7dx+e9g4hyjf8RoaBMdISzYskd98IBJh0VY4S78=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB3188.eurprd08.prod.outlook.com (52.134.94.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Thu, 21 Feb 2019 12:19:13 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd%2]) with mapi id 15.20.1643.016; Thu, 21 Feb 2019
 12:19:13 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, nd <nd@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Topic: [PATCH v4 0/7] VSP1: Display writeback support
Thread-Index: AQHUx4SuF0wk/rt+2UuytgV1PyNhIaXp7lqAgAAYUYCAAAOIgIAAJhOA
Date:   Thu, 21 Feb 2019 12:19:13 +0000
Message-ID: <20190221121913.l7e5zlitcfpvkupi@DESKTOP-E1NTVVP.localdomain>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190218122257.o5blxfs7jo5xu7ge@DESKTOP-E1NTVVP.localdomain>
 <20190221082317.GB3451@pendragon.ideasonboard.com>
 <20190221095019.rht64aylk52jqe5r@DESKTOP-E1NTVVP.localdomain>
 <20190221100257.GD3451@pendragon.ideasonboard.com>
In-Reply-To: <20190221100257.GD3451@pendragon.ideasonboard.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.51]
x-clientproxiedby: LO2P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::36) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 001bbe95-a64d-411e-d3b2-08d697f6ca20
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB3188;
x-ms-traffictypediagnostic: AM0PR08MB3188:
x-ms-exchange-purlcount: 2
nodisclaimer: True
x-microsoft-exchange-diagnostics: 1;AM0PR08MB3188;20:B3H/1nxlPDhYrMN1UfRZSHfcRKAyw3pFg8Ik5XpduRyESO3n7yzPThlDdd1hL+tHcsgAqH2Ld/igVZb6/HyALy10ZYB//YJZsA8COe5SnB8upX1fEdGk7i6H3k4o9ztHrJNQIMH5+P9yq5qNMxNvvT0npJAX3wtWDIxWxC/EdY8=
x-microsoft-antispam-prvs: <AM0PR08MB3188DB5EC7C770A52D6F7DBCF07E0@AM0PR08MB3188.eurprd08.prod.outlook.com>
x-forefront-prvs: 09555FB1AD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(366004)(376002)(396003)(55674003)(199004)(189003)(66066001)(476003)(186003)(7736002)(26005)(14454004)(305945005)(11346002)(446003)(81156014)(8676002)(81166006)(2906002)(256004)(14444005)(486006)(44832011)(6916009)(86362001)(105586002)(106356001)(6306002)(9686003)(229853002)(6486002)(6512007)(6436002)(8936002)(102836004)(71190400001)(53936002)(1076003)(68736007)(54906003)(71200400001)(4326008)(6246003)(6116002)(33896004)(3846002)(5660300002)(6346003)(25786009)(58126008)(76176011)(72206003)(52116002)(6506007)(386003)(478600001)(966005)(99286004)(316002)(97736004)(93886005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB3188;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GPHmTIyUqpdb/qnXWRwvyk1xnwUaZDgiZ/hjh3A2UnZToMMfiy8B5oS4ObBmUP4JNv0ZbUxvJgaeKUqVpE22fvf0qpcodwacS7GUxHzn94bGiRwOIvJrtWlXTrCnZu7TsBT6gHJcIf8SJ63y3ITdRHYS6ooW7BcepRKhkCEUl3G8c6VT5RlJHnco7xy4/4D3/hcMvAqwCghwdo7ppE9n1os9cjmFKf0n/Nr0kuPFzIgGKRNTur61B3mXeqPQX5n7rV10nqkYVcPEE8B7WFYMHhi39kExGnlwwAvwBGdXHBCHVfrSB/H2GVUUb1dqLUnFx17vXopv0rJeV/kL0eSiFzZcd6IqWdoWTtWo+JwaQNv/HjSLr9CIIzdb/z8tp2QkOs3k5HgDf+a31nI+z0jlvBuaRoMuOBTAFUytlD3RYjw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <673D4A59BBC8364FA22CF6EDEC36FCCC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 001bbe95-a64d-411e-d3b2-08d697f6ca20
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2019 12:19:12.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3188
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Thu, Feb 21, 2019 at 12:02:57PM +0200, Laurent Pinchart wrote:
> Hi Brian,
>=20
> On Thu, Feb 21, 2019 at 09:50:19AM +0000, Brian Starkey wrote:
> > On Thu, Feb 21, 2019 at 10:23:17AM +0200, Laurent Pinchart wrote:
> > > On Mon, Feb 18, 2019 at 12:22:58PM +0000, Brian Starkey wrote:
> > >> On Sun, Feb 17, 2019 at 04:48:45AM +0200, Laurent Pinchart wrote:
> > >>> Hello,
> > >>>=20
> > >>> This patch series implements display writeback support for the R-Ca=
r
> > >>> Gen3 platforms in the VSP1 driver.
> > >>>=20
> > >>> DRM/KMS provides a writeback API through a special type of writebac=
k
> > >>> connectors. This series takes a different approach by exposing writ=
eback
> > >>> as a V4L2 device. While there is nothing fundamentally wrong with
> > >>> writeback connectors, display for R-Car Gen3 platforms relies on th=
e
> > >>> VSP1 driver behind the scene, which already implements V4L2 support=
.
> > >>> Enabling writeback through V4L2 is thus significantly easier in thi=
s
> > >>> case.
> > >>=20
> > >> How does this look to an application? (I'm entirely ignorant about
> > >> R-Car). They are interacting with the DRM device, and then need to
> > >> open and configure a v4l2 device to get the writeback? Can the proce=
ss
> > >> which isn't controlling the DRM device independently capture the
> > >> screen output?
> > >>=20
> > >> I didn't see any major complication to implementing this as a
> > >> writeback connector. If you want/need to use the vb2_queue, couldn't
> > >> you just do that entirely from within the kernel?
> > >>=20
> > >> Honestly (predictably?), to me it seems like a bad idea to introduce=
 a
> > >> second, non-compatible interface for display writeback. Any
> > >> application interested in display writeback (e.g. compositors) will
> > >> need to implement both in order to support all HW. drm_hwcomposer
> > >> already supports writeback via DRM writeback connectors.
> > >>=20
> > >> While I can see the advantages of having writeback exposed via v4l2
> > >> for streaming use-cases, I think it would be better to have it done =
in
> > >> such a way that it works for all writeback connectors, rather than
> > >> being VSP1-specific. That would allow any application to choose
> > >> whichever method is most appropriate for their use-case, without
> > >> limiting themselves to a subset of hardware.
> > >=20
> > > So I gave writeback connectors a go, and it wasn't very pretty.
> >=20
> > Sorry you didn't have a good time :-(
>=20
> No worries. That was to be expected with such young code :-)
>=20
> > > There writeback support in the DRM core leaks jobs,
> >=20
> > Is this the cleanup on check fail, or something else?
>=20
> Yes, that's the problem. I have patches for it that I will post soon.
>=20
> > One possible pitfall is that you must set the job in the connector
> > state to NULL after you call drm_writeback_queue_job(). The API there
> > could easily be changed to pass in the connector_state and clear it in
> > drm_writeback_queue_job() instead of relying on drivers to do it.
>=20
> I also have a patch for that :-)
>=20
> > > and is missing support for
> > > the equivalent of .prepare_fb()/.cleanup_fb(), which requires per-job
> > > driver-specific data. I'm working on these issues and will submit
> > > patches.
> >=20
> > Hm, yes that didn't occur to me; we don't have a prepare_fb callback.
> >=20
> > > In the meantime, I need to test my implementation, so I need a comman=
d
> > > line application that will let me exercise the API. I assume you've
> > > tested your code, haven't you ? :-) Could you tell me how I can test
> > > writeback ?
> >=20
> > Indeed, there's igts on the list which I wrote and tested:
> >=20
> > https://patchwork.kernel.org/patch/10764975/
>=20
> Will you get these merged ? Pushing everybody to use the writeback
> connector API without any test is mainline isn't nice, it almost makes
> me want to go back to V4L2.

I wasn't trying to be pushy - I only shared my opinion that I didn't
think it was a good idea to introduce a second display writeback API,
when we already have one. You're entirely entitled to ignore my
opinion.

The tests have been available since the very early versions of the
writeback series. I don't know what's blocking them from merging, I
haven't been tracking it very closely.

If you'd be happy to provide your review and test on them, that may
help the process along?

>=20
> igt test cases are nice to have, but what I need now is a tool to
> execise the API manually, similar to modetest, with command line
> parameters to configure the device, and the ability to capture frames to
> disk using writeback. How did you perform such tests when you developed
> writeback support ?
>=20

I used a pre-existing internal tool which does exactly that.

I appreciate that we don't have upstream tooling for writeback. As you
say, it's a young API (well, not by date, but certainly by usage).

I also do appreciate you taking the time to consider it, identifying
issues which we did not, and for fixing them. The only way it stops
being a young API, with bugs and no tooling, is if people adopt it.

Thanks,
-Brian

> > And there's support in drm_hwcomposer (though I must admit I haven't
> > personally run the drm_hwc code):
> >=20
> > https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer/merge_requ=
ests/3
>=20
> That won't help me much as I don't have an android port for the R-Car
> boards.
>=20
> > I'm afraid I haven't really touched any of the writeback code for a
> > couple of years - Liviu picked that up. He's on holiday until Monday,
> > but he should be able to help with the status of the igts.
> >=20
> > Hope that helps,
> >=20
> > >>> The writeback pixel format is restricted to RGB, due to the VSP1
> > >>> outputting RGB to the display and lacking a separate colour space
> > >>> conversion unit for writeback. The resolution can be freely picked =
by
> > >>> will result in cropping or composing, not scaling.
> > >>>=20
> > >>> Writeback requests are queued to the hardware on page flip (atomic
> > >>> flush), and complete at the next vblank. This means that a queued
> > >>> writeback buffer will not be processed until the next page flip, bu=
t
> > >>> once it starts being written to by the VSP, it will complete at the=
 next
> > >>> vblank regardless of whether another page flip occurs at that time.
> > >>=20
> > >> This sounds the same as mali-dp, and so fits directly with the
> > >> semantics of writeback connectors.
> > >>=20
> > >>> The code is based on a merge of the media master branch, the drm-ne=
xt
> > >>> branch and the R-Car DT next branch. For convenience patches can be
> > >>> found at
> > >>>=20
> > >>> 	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback
> > >>>=20
> > >>> Kieran Bingham (2):
> > >>>   Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
> > >>>   media: vsp1: Provide a writeback video device
> > >>>=20
> > >>> Laurent Pinchart (5):
> > >>>   media: vsp1: wpf: Fix partition configuration for display pipelin=
es
> > >>>   media: vsp1: Replace leftover occurrence of fragment with body
> > >>>   media: vsp1: Fix addresses of display-related registers for VSP-D=
L
> > >>>   media: vsp1: Refactor vsp1_video_complete_buffer() for later reus=
e
> > >>>   media: vsp1: Replace the display list internal flag with a flags =
field
> > >>>=20
> > >>>  drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
> > >>>  drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
> > >>>  drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
> > >>>  drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
> > >>>  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
> > >>>  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
> > >>>  drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
> > >>>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
> > >>>  drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++=
----
> > >>>  drivers/media/platform/vsp1/vsp1_video.h |   6 +
> > >>>  drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
> > >>>  11 files changed, 378 insertions(+), 75 deletions(-)
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart

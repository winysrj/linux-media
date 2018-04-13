Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:10289 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752512AbeDMCSV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 22:18:21 -0400
Message-ID: <87vacv97ik.wl%kuninori.morimoto.gx@renesas.com>
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] media: rcar-vin: Fix image alignment for setting pre clipping
To: =?ISO-8859-1?Q?=22Niklas_S=F6derlund=22?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Niklas Soderlund <niklas.soderlund@ragnatech.se>,
        <koji.matsuoka.xm@renesas.com>, Magnus <magnus.damm@gmail.com>,
        Laurent <laurent.pinchart@ideasonboard.com>,
        shimoda <yoshihiro.shimoda.uh@renesas.com>,
        shiiba <naoya.shiiba.nx@renesas.com>,
        sakato <ryusuke.sakato.bx@renesas.com>,
        Kihara <takeshi.kihara.df@renesas.com>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        <hien.dang.eb@renesas.com>, <khiem.nguyen.xt@renesas.com>,
        <kouei.abe.cp@renesas.com>, <harunobu.kurokawa.dn@renesas.com>,
        <hiroyuki.yokoyama.vx@renesas.com>
In-Reply-To: <87bmepxga1.wl%kuninori.morimoto.gx@renesas.com>
References: <redmine.issue-121985.20170421084025@dm.renesas.com> <redmine.issue-121985.20170421084025.54bb05cdb01b9ffe@dm.renesas.com> <87tw5iuoqa.wl%kuninori.morimoto.gx@renesas.com> <20170421130432.GT28868@bigcity.dyn.berto.se> <877f2awv7u.wl%kuninori.morimoto.gx@renesas.com> <87bmepxga1.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Apr 2018 02:18:13 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

In Video Pixel/Line Pre-Clip Register, the setting value can be
set in 1 line unit, but it can only be specified as a multiple of
4 by v4l_bound_align_image function().
So correct that it can be specified in 1 line unit with this patch.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/pl=
atform/rcar-vin/rcar-v4l2.c
index 22a6ecc..71ae65b 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -409,8 +409,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		max_rect.height =3D vin->source.height;
 		v4l2_rect_map_inside(&r, &max_rect);
=20
-		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
-				      &r.height, 4, vin->source.height, 2, 0);
+		v4l_bound_align_image(&r.width, 6, vin->source.width, 0,
+				      &r.height, 2, vin->source.height, 0, 0);
=20
 		r.top  =3D clamp_t(s32, r.top, 0, vin->source.height - r.height);
 		r.left =3D clamp_t(s32, r.left, 0, vin->source.width - r.width);
--=20
1.9.1

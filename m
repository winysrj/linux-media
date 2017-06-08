Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:36839 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751512AbdFHDW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 23:22:57 -0400
Message-ID: <1496892171.22652.2.camel@mtksdaap41>
Subject: Re: [PATCH] [media] mtk-mdp: Fix g_/s_selection capture/compose
 logic
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        "Eddie Huang" <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Thu, 8 Jun 2017 11:22:51 +0800
In-Reply-To: <a8c1da24-d812-7c4d-a05d-34cb90edddf5@linaro.org>
References: <1492057130-1194-1-git-send-email-minghsiu.tsai@mediatek.com>
         <a8c1da24-d812-7c4d-a05d-34cb90edddf5@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Stanimir Varbanov,

I have upload patch v2. 
https://patchwork.kernel.org/patch/9723463/

Could you review it? Thanks


On Thu, 2017-04-27 at 17:42 +0300, Stanimir Varbanov wrote:
> Hi,
> 
> On 04/13/2017 07:18 AM, Minghsiu Tsai wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> > 
> > Experiments show that the:
> >  (1) mtk-mdp uses the _MPLANE form of CAPTURE/OUTPUT
> >  (2) CAPTURE types use CROP targets, and OUTPUT types use COMPOSE targets
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > 
> > ---
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > index 13afe48..8ab7ca0 100644
> > --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > @@ -837,12 +837,12 @@ static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
> >  	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
> >  	bool valid = false;
> >  
> > -	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > -		if (mtk_mdp_is_target_compose(s->target))
> > -			valid = true;
> > -	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> >  		if (mtk_mdp_is_target_crop(s->target))
> >  			valid = true;
> > +	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > +		if (mtk_mdp_is_target_compose(s->target))
> > +			valid = true;
> >  	}
> 
> Using MPLANE formats in g/s_selection violates the v4l2 spec. See [1].
> 
> <snip>
> 

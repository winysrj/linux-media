Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:55811 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932077AbdBHBi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 20:38:57 -0500
Message-ID: <1486517907.18649.1.camel@mtksdaap41>
Subject: Re: [PATCH] [media] mtk-vcodec: fix build errors without DEBUG
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Osciak <posciak@chromium.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support"
        <linux-mediatek@lists.infradead.org>
Date: Wed, 8 Feb 2017 09:38:27 +0800
In-Reply-To: <CAGS+omAU7UohsUkXwwHyhNh_dSX=R9tLKYvSV5767m81sTf_RA@mail.gmail.com>
References: <1486453244-26094-1-git-send-email-minghsiu.tsai@mediatek.com>
         <CAGS+omAU7UohsUkXwwHyhNh_dSX=R9tLKYvSV5767m81sTf_RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-02-07 at 20:17 +0800, Daniel Kurtz wrote:
> On Tue, Feb 7, 2017 at 3:40 PM, Minghsiu Tsai
> <minghsiu.tsai@mediatek.com> wrote:
> > Fix build errors after removing DEBUG definition.
> 
> It would be useful to specify which build errors were fixed by this
> patch, and a brief description of why - namely because when DEBUG is
> not defined, mtk_v4l2_debug() is an empty macros, and therefore the
> arguments are unused.
> 
> With an updated commit message, this patch is:
> 
> Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> 

Hi Daniel,
Thanks for your review and comment. I will update it soon.

> >
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 9 ++++-----
> >  drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    | 5 ++---
> >  drivers/media/platform/mtk-vcodec/venc_vpu_if.c    | 4 +---
> >  3 files changed, 7 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> > index 0746592..6219c7d 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> > @@ -1126,15 +1126,14 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
> >                  * if there is no SPS header or picture info
> >                  * in bs
> >                  */
> > -               int log_level = ret ? 0 : 1;
> >
> >                 src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> >                 v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> >                                         VB2_BUF_STATE_DONE);
> > -               mtk_v4l2_debug(log_level,
> > -                               "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
> > -                               ctx->id, src_buf->index,
> > -                               src_mem.size, ret, res_chg);
> > +               mtk_v4l2_debug(ret ? 0 : 1,
> > +                              "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
> > +                              ctx->id, src_buf->index,
> > +                              src_mem.size, ret, res_chg);
> >                 return;
> >         }
> >
> > diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
> > index 5a24c51..1abd14e 100644
> > --- a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
> > +++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
> > @@ -70,9 +70,8 @@ void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv)
> >  static int vcodec_vpu_send_msg(struct vdec_vpu_inst *vpu, void *msg, int len)
> >  {
> >         int err;
> > -       uint32_t msg_id = *(uint32_t *)msg;
> >
> > -       mtk_vcodec_debug(vpu, "id=%X", msg_id);
> > +       mtk_vcodec_debug(vpu, "id=%X", *(uint32_t *)msg);
> >
> >         vpu->failure = 0;
> >         vpu->signaled = 0;
> > @@ -80,7 +79,7 @@ static int vcodec_vpu_send_msg(struct vdec_vpu_inst *vpu, void *msg, int len)
> >         err = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
> >         if (err) {
> >                 mtk_vcodec_err(vpu, "send fail vpu_id=%d msg_id=%X status=%d",
> > -                              vpu->id, msg_id, err);
> > +                              vpu->id, *(uint32_t *)msg, err);
> >                 return err;
> >         }
> >
> > diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> > index a01c759..0d882ac 100644
> > --- a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> > +++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> > @@ -79,10 +79,8 @@ static int vpu_enc_send_msg(struct venc_vpu_inst *vpu, void *msg,
> >
> >         status = vpu_ipi_send(vpu->dev, vpu->id, msg, len);
> >         if (status) {
> > -               uint32_t msg_id = *(uint32_t *)msg;
> > -
> >                 mtk_vcodec_err(vpu, "vpu_ipi_send msg_id %x len %d fail %d",
> > -                              msg_id, len, status);
> > +                              *(uint32_t *)msg, len, status);
> >                 return -EINVAL;
> >         }
> >         if (vpu->failure)
> > --
> > 1.9.1
> >



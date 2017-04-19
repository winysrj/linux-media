Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59041
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762350AbdDSK4x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 06:56:53 -0400
Date: Wed, 19 Apr 2017 07:56:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] media: mtk-vcodec: remove informative log
Message-ID: <20170419075643.0a04af21@vento.lan>
In-Reply-To: <1491390599.32502.1.camel@mtksdaap41>
References: <1491389669-32737-1-git-send-email-minghsiu.tsai@mediatek.com>
        <1491390599.32502.1.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Apr 2017 19:09:59 +0800
Tiffany Lin <tiffany.lin@mediatek.com> escreveu:

> On Wed, 2017-04-05 at 18:54 +0800, Minghsiu Tsai wrote:
> > Driver is stable. Remove DEBUG definition from driver.
> > 
> > There are debug message in /var/log/messages if DEBUG is defined,
> > such as:
> > [MTK_V4L2] level=0 fops_vcodec_open(),170: decoder capability 0
> > [MTK_V4L2] level=0 fops_vcodec_open(),177: 16000000.vcodec decoder [0]
> > [MTK_V4L2] level=0 fops_vcodec_release(),200: [0] decoder
> > 
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>  
> Acked-by:Tiffany Lin <Tiffany.lin@mediatek.com>
> 
> > ---
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> > index 7d55975..1248083 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> > @@ -31,7 +31,6 @@ struct mtk_vcodec_mem {
> >  extern int mtk_v4l2_dbg_level;
> >  extern bool mtk_vcodec_dbg;
> >  
> > -#define DEBUG	1
> >  
> >  #if defined(DEBUG)
> >    

After this patch, building the Kernel with W=1 now shows warnings:

drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_dec_pw_on':
drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:114:51: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
   mtk_v4l2_err("pm_runtime_get_sync fail %d", ret);
                                                   ^

I wrote a patch fixing it, as this is really a trivial issue.

Yet, after that, this one still remains:


drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c: In function 'mtk_vdec_pic_info_update':
drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:284:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret;
      ^~~


Shouldn't be mtk_vdec_pic_info_update() returning an error code?


Also, IMHO, at least errors should be shown at dmesg.

Thanks,
Mauro

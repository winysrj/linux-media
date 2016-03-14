Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5802 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965061AbcCNMWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 08:22:47 -0400
Message-ID: <1457958162.8737.3.camel@mtksdaap41>
Subject: Re: [PATCH] media: v4l2-compat-ioctl32: fix missing reserved field
 copy in put_v4l2_create32
From: tiffany lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 14 Mar 2016 20:22:42 +0800
In-Reply-To: <20160314082859.31340fb6@recife.lan>
References: <1457952106-38215-1-git-send-email-tiffany.lin@mediatek.com>
	 <20160314082859.31340fb6@recife.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-03-14 at 08:28 -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Mar 2016 18:41:46 +0800
> Tiffany Lin <tiffany.lin@mediatek.com> escreveu:
> 
> > Change-Id: Idac449fae5059a3ce255340e6da491f8bd83af7a
> 
> We don't need change-id at the Kernel, but we do need a proper patch
> description.
> 
Hi Mauro,

Sorry, I accidentally add change-id in this patch.
I had remove change-id and add patch description in 
[PATCH v2] media: v4l2-compat-ioctl32: fix missing reserved field copy
in put_v4l2_create32

best regards,
Tiffany


> Regards,
> Mauro
> 
> > ---
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index f38c076..109f687 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -280,7 +280,8 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
> >  static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
> >  {
> >  	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
> > -	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format)))
> > +	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format)) ||
> > +	    copy_to_user(up->reserved, kp->reserved, sizeof(kp->reserved)))
> >  		return -EFAULT;
> >  	return __put_v4l2_format32(&kp->format, &up->format);
> >  }



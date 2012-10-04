Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60050 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDIrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 04:47:12 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD00LSV1PSZVU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 17:47:10 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.51.52])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBD00G5D1QMM530@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 17:47:10 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: rahul.sharma@samsung.com,
	'Tomasz Stanislawski' <t.stanislaws@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: 'SUNIL JOSHI' <joshi@samsung.com>, r.sh.open@gmail.com,
	'Dave Airlie' <airlied@gmail.com>
References: <8952601.531301349336373038.JavaMail.weblogic@epml07>
In-reply-to: <8952601.531301349336373038.JavaMail.weblogic@epml07>
Subject: RE: [PATCH v1 01/14] media: s5p-hdmi: add HPD GPIO to platform data
Date: Thu, 04 Oct 2012 17:47:09 +0900
Message-id: <001301cda20c$d7691db0$863b5910$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Media guys,

This is dependent of exynos drm patch set to be merged to mainline so if
there is no problem then please, give me ack so that I can merge this patch
with exynos drm patch set.

Thanks,
Inki Dae

> -----Original Message-----
> From: RAHUL SHARMA [mailto:rahul.sharma@samsung.com]
> Sent: Thursday, October 04, 2012 4:40 PM
> To: Tomasz Stanislawski; Kyungmin Park; linux-arm-
> kernel@lists.infradead.org; linux-media@vger.kernel.org
> Cc: In-Ki Dae; SUNIL JOSHI; r.sh.open@gmail.com
> Subject: Re: [PATCH v1 01/14] media: s5p-hdmi: add HPD GPIO to platform
> data
> 
> Hi Mr. Tomasz, Mr. Park, list,
> 
> First patch in the following set belongs to s5p-media, rest to exynos-drm.
> Please review the media patch so that It can be merged for mainline.
> 
> regards,
> Rahul Sharma
> 
> On Thu, Oct 4, 2012 at 9:12 PM, Rahul Sharma <rahul.sharma@samsung.com>
> wrote:
> > From: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >
> > This patch extends s5p-hdmi platform data by a GPIO identifier for
> > Hot-Plug-Detection pin.
> >
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  include/media/s5p_hdmi.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
> > index 361a751..181642b 100644
> > --- a/include/media/s5p_hdmi.h
> > +++ b/include/media/s5p_hdmi.h
> > @@ -20,6 +20,7 @@ struct i2c_board_info;
> >   * @hdmiphy_info: template for HDMIPHY I2C device
> >   * @mhl_bus: controller id for MHL control bus
> >   * @mhl_info: template for MHL I2C device
> > + * @hpd_gpio: GPIO for Hot-Plug-Detect pin
> >   *
> >   * NULL pointer for *_info fields indicates that
> >   * the corresponding chip is not present
> > @@ -29,6 +30,7 @@ struct s5p_hdmi_platform_data {
> >         struct i2c_board_info *hdmiphy_info;
> >         int mhl_bus;
> >         struct i2c_board_info *mhl_info;
> > +       int hpd_gpio;
> >  };
> >
> >  #endif /* S5P_HDMI_H */
> > --
> > 1.7.0.4
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33719 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbeDQIwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 04:52:21 -0400
Date: Tue, 17 Apr 2018 05:52:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 01/16] omap: omap-iommu.h: allow building drivers with
 COMPILE_TEST
Message-ID: <20180417055215.084ec137@vento.lan>
In-Reply-To: <d732ddf4-db42-3549-15d1-90bfc8546a48@gentoo.org>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <6741dd205de1e7d4e80a93386095db2a0c604bb5.1522949748.git.mchehab@s-opensource.com>
        <d732ddf4-db42-3549-15d1-90bfc8546a48@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 8 Apr 2018 12:12:17 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Am 05.04.2018 um 19:54 schrieb Mauro Carvalho Chehab:
> > Drivers that depend on omap-iommu.h (currently, just omap3isp)
> > need a stub implementation in order to be built with COMPILE_TEST.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  include/linux/omap-iommu.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
> > index c1aede46718b..0c21fc5b002e 100644
> > --- a/include/linux/omap-iommu.h
> > +++ b/include/linux/omap-iommu.h
> > @@ -13,7 +13,12 @@
> >  #ifndef _OMAP_IOMMU_H_
> >  #define _OMAP_IOMMU_H_
> >  
> > +#ifdef CONFIG_OMAP_IOMMU
> >  extern void omap_iommu_save_ctx(struct device *dev);
> >  extern void omap_iommu_restore_ctx(struct device *dev);
> > +#else
> > +static inline void omap_iommu_save_ctx(struct device *dev) {};
> > +static inline void omap_iommu_restore_ctx(struct device *dev) {};  
> 
> The semicolons at end of line are unnecessary.
> 
> > +#endif
> >  
> >  #endif
> >   

Hi Matthias,

Somehow, I missed your comment.

New version enclosed.


Thanks,
Mauro


[PATCH v3] omap: omap-iommu.h: allow building drivers with COMPILE_TEST

Drivers that depend on omap-iommu.h (currently, just omap3isp)
need a stub implementation in order to be built with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/omap-iommu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
index c1aede46718b..0c21fc5b002e 100644
--- a/include/linux/omap-iommu.h
+++ b/include/linux/omap-iommu.h
@@ -13,7 +13,12 @@
 #ifndef _OMAP_IOMMU_H_
 #define _OMAP_IOMMU_H_
 
+#ifdef CONFIG_OMAP_IOMMU
 extern void omap_iommu_save_ctx(struct device *dev);
 extern void omap_iommu_restore_ctx(struct device *dev);
+#else
+static inline void omap_iommu_save_ctx(struct device *dev) {} 
+static inline void omap_iommu_restore_ctx(struct device *dev) {} 
+#endif
 
 #endif

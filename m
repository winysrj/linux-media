Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54813 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754383AbcL0Lqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 06:46:55 -0500
Date: Tue, 27 Dec 2016 13:46:50 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] coda: fix Freescale firmware location
Message-ID: <20161227114650.hzuikmdrjsinsb2i@tarshish>
References: <628638bcda35ffe92f931f67560ed01cba970067.1482833176.git.baruch@tkos.co.il>
 <CAOMZO5CvmbVmfS8LOYc1J3MDm5dxQmD=aQYr+h6wM2A9d4SPBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CvmbVmfS8LOYc1J3MDm5dxQmD=aQYr+h6wM2A9d4SPBA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Tue, Dec 27, 2016 at 09:26:16AM -0200, Fabio Estevam wrote:
> 2016-12-27 8:06 GMT-02:00 Baruch Siach <baruch@tkos.co.il>:
> > The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
> > by default. Make coda conform with that to ease the update path.
> >
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index 9e6bdafa16f5..140c02715855 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -2078,7 +2078,7 @@ enum coda_platform {
> >  static const struct coda_devtype coda_devdata[] = {
> >         [CODA_IMX27] = {
> >                 .firmware     = {
> > -                       "vpu_fw_imx27_TO2.bin",
> > +                       "vpu/vpu_fw_imx27_TO2.bin",
> >                         "v4l-codadx6-imx27.bin"
> >                 },
> 
> What about just adding the new path without removing the original one?
> This way we avoid breakage for the users that use
> "vpu_fw_imx27_TO2.bin" path.

I considered that. Support for Freescale provided firmware is quite new 
(v4.6+), so I was not sure that supporting the current location is worth the 
bloat. What do others think?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51147 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeEVLHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:07:51 -0400
Message-ID: <1526987269.3671.19.camel@pengutronix.de>
Subject: Re: [PATCH] gpu: ipu-v3: Fix BT1120 interlaced CCIR codes
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 22 May 2018 13:07:49 +0200
In-Reply-To: <cec007aa-d0b7-0802-d771-355a29751a2b@denx.de>
References: <20180407130428.24833-1-marex@denx.de>
         <1526658687.3948.15.camel@pengutronix.de>
         <cec007aa-d0b7-0802-d771-355a29751a2b@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Fri, 2018-05-18 at 18:21 +0200, Marek Vasut wrote:
> On 05/18/2018 05:51 PM, Philipp Zabel wrote:
> > Hi Marek,
> > 
> > On Sat, 2018-04-07 at 15:04 +0200, Marek Vasut wrote:
> > > The BT1120 interlaced CCIR codes are the same as BT656 ones
> > > and different than BT656 progressive CCIR codes, fix this.
> > 
> > thank you for the patch, and sorry for the delay.
> > 
> > > Signed-off-by: Marek Vasut <marex@denx.de>
> > > Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
> > > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > > ---
> > >  drivers/gpu/ipu-v3/ipu-csi.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
> > > index caa05b0702e1..301a729581ce 100644
> > > --- a/drivers/gpu/ipu-v3/ipu-csi.c
> > > +++ b/drivers/gpu/ipu-v3/ipu-csi.c
> > > @@ -435,12 +435,16 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
> > >  		break;
> > >  	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
> > >  	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
> > > -	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
> > > -	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
> > >  		ipu_csi_write(csi, 0x40030 | CSI_CCIR_ERR_DET_EN,
> > >  				   CSI_CCIR_CODE_1);
> > >  		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
> > >  		break;
> > > +	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
> > > +	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
> > > +		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN, CSI_CCIR_CODE_1);
> > > +		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
> > > +		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
> > 
> > If these are the same as BT656 codes (so this case would be for PAL?),
> > could this just be moved up into the IPU_CSI_CLK_MODE_CCIR656_INTERLACED
> > case? Would the NTSC CCIR codes be the same as well?
> 
> Dunno, I don't have any NTSC device to test. But the above was tested
> with a PAL device I had.
> 
> I think the CCIR codes are different from BT656, although I might be wrong.

The driver currently has:

        case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
                if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
                        /*
                         * PAL case
                         *
                         * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
                         * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
                         * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
                         * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
                         */
                        height = 625; /* framelines for PAL */

                        ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
                                          CSI_CCIR_CODE_1);
                        ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
                        ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
                } else if (mbus_fmt->width == 720 && mbus_fmt->height == 480) {                           
                        /*
                         * NTSC case
                         *
                         * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
                         * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
                         * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
                         * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
                         */
                        height = 525; /* framelines for NTSC */

                        ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
                                          CSI_CCIR_CODE_1);
                        ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
                        ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
                } else {
                        dev_err(csi->ipu->dev,
                                "Unsupported CCIR656 interlaced video mode\n");
                        spin_unlock_irqrestore(&csi->lock, flags);
                        return -EINVAL;
                }
                break;

The PAL codes are exactly the same as in your patch. That's why I wonder
whether we should just move
	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
up before
        case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
as follows:

----------8<----------
diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index caa05b0702e1..7e96382f9cb1 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -396,6 +396,8 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
                ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
                break;
        case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
+       case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
+       case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
                if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
                        /*
                         * PAL case
@@ -435,8 +437,6 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
                break;
        case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
        case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
-       case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
-       case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
                ipu_csi_write(csi, 0x40030 | CSI_CCIR_ERR_DET_EN,
                                   CSI_CCIR_CODE_1);
                ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
---------->8----------

Does this work for you?

regards
Philipp

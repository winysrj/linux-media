Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57807 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeFDIra (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 04:47:30 -0400
Message-ID: <1528102047.5808.11.camel@pengutronix.de>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Date: Mon, 04 Jun 2018 10:47:27 +0200
In-Reply-To: <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
References: <m37eobudmo.fsf@t19.piap.pl>
         <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
         <m3tvresqfw.fsf@t19.piap.pl>
         <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
         <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
         <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
         <m3h8mxqc7t.fsf@t19.piap.pl>
         <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
         <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
         <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com>
         <m3lgc2q5vl.fsf@t19.piap.pl>
         <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com>
         <m38t81plry.fsf@t19.piap.pl>
         <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com>
         <m336y9ouc4.fsf@t19.piap.pl>
         <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
         <m3sh66omdk.fsf@t19.piap.pl> <1527858788.5913.2.camel@pengutronix.de>
         <05703b20-3280-3bdd-c438-dfce8e475aaa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-06-02 at 10:45 -0700, Steve Longerbeam wrote:
> 
> On 06/01/2018 06:13 AM, Philipp Zabel wrote:
> > Hi Krzysztof,
> > 
> > On Fri, 2018-06-01 at 12:02 +0200, Krzysztof Hałasa wrote:
> > > Steve Longerbeam <slongerbeam@gmail.com> writes:
> > > 
> > > > I tend to agree, I've found conflicting info out there regarding
> > > > PAL vs. NTSC field order. And I've never liked having to guess
> > > > at input analog standard based on input # lines. I will go ahead
> > > > and remove the field order override code.
> > > 
> > > I've merged your current fix-csi-interlaced.2 branch (2018-06-01
> > > 00:06:45 UTC 22ad9f30454b6e46979edf6f8122243591910a3e) along with
> > > "media: adv7180: fix field type" commit and NTSC camera:
> > > 
> > > media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:alternate]"
> > > media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
> > > media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x480 field:interlaced/-bt/-tb]"
> > > 
> > > correctly sets:
> > > 
> > > "adv7180 2-0020":0 [fmt:UYVY2X8/720x480 field:alternate]
> > > "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x480 field:alternate]
> > > "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x480 field:alternate]
> > > "ipu2_csi1":0      [fmt:UYVY2X8/720x480 field:alternate]
> > > "ipu2_csi1":2      [fmt:AYUV32/720x480 field:interlaced/-bt/-tb]
> > > 
> > > but all 3 cases seem to produce top-first interlaced frames.
> > > The CCIR_CODE_* register dump shows no differences:
> > > 2a38014: 010D07DF 00040596 00FF0000
> > > 
> > > ...it's because the code in drivers/gpu/ipu-v3/ipu-csi.c still sets the
> > > registers depending on the height of the image.
> > 
> > Exactly.
> > 
> > >   Hovewer, I'm using 480
> > > lines here, so it should be B-T instead.
> > 
> > My understanding is that the CCIR codes for height == 480 (NTSC)
> > currently capture the second field (top) first, assuming that for NTSC
> > the EAV/SAV codes are bottom-field-first.
> > 
> > So the CSI captures SEQ_TB for both PAL and NTSC: The three-bit values
> > in CCIR_CODE_2/3 are in H,V,F order, and the NTSC case has F=1 for the
> > field that is captured first, where F=1 is the field that is marked as
> > second field on the wire, so top. Which means that the captured frame
> > has two fields captured across frame boundaries, which might be
> > problematic if the source data was originally progressive.
> 
> I agree, for NTSC the CSI will drop the first B field and start capturing
> at the T field, and then capture fields across frame boundaries. At
> least, that is if we understand how these CCIR registers work: the
> CSI will look for H-S-V codes for the start and end of active and blanking
> lines, that match the codes written to CCIR_CODE_1/2 for fields 0/1.
> 
> I think this must be legacy code from a Freescale BSP requirement
> that the CSI must always capture in T-B order. We should remove this
> code, so that the CSI always captures field 0 followed by field 1, 
> irrespective
> of field affinity, as in:
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
> index 5450a2d..b8b9b6d 100644
> --- a/drivers/gpu/ipu-v3/ipu-csi.c
> +++ b/drivers/gpu/ipu-v3/ipu-csi.c
> @@ -398,41 +398,20 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
>                  break;
>          case IPU_CSI_CLK_MODE_CCIR656_INTERLACED:
>                  if (mbus_fmt->width == 720 && mbus_fmt->height == 576) {
> -                       /*
> -                        * PAL case
> -                        *
> -                        * Field0BlankEnd = 0x6, Field0BlankStart = 0x2,
> -                        * Field0ActiveEnd = 0x4, Field0ActiveStart = 0
> -                        * Field1BlankEnd = 0x7, Field1BlankStart = 0x3,
> -                        * Field1ActiveEnd = 0x5, Field1ActiveStart = 0x1
> -                        */
>                          height = 625; /* framelines for PAL */
> -
> -                       ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
> -                                         CSI_CCIR_CODE_1);
> -                       ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
> -                       ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>                  } else if (mbus_fmt->width == 720 && mbus_fmt->height 
> == 480) {
> -                       /*
> -                        * NTSC case
> -                        *
> -                        * Field0BlankEnd = 0x7, Field0BlankStart = 0x3,
> -                        * Field0ActiveEnd = 0x5, Field0ActiveStart = 0x1
> -                        * Field1BlankEnd = 0x6, Field1BlankStart = 0x2,
> -                        * Field1ActiveEnd = 0x4, Field1ActiveStart = 0
> -                        */
>                          height = 525; /* framelines for NTSC */
> -
> -                       ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
> -                                         CSI_CCIR_CODE_1);
> -                       ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
> -                       ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>                  } else {
>                          dev_err(csi->ipu->dev,
>                                  "Unsupported CCIR656 interlaced video 
> mode\n");
>                          spin_unlock_irqrestore(&csi->lock, flags);
>                          return -EINVAL;
>                  }
> +
> +               ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN,
> +                             CSI_CCIR_CODE_1);
> +               ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
> +               ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);

This will require a negative interlace offset in the IDMAC to produce
seq-bt -> interlaced-bt for NTSC.

regards
Philipp

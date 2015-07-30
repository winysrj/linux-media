Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38240 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbG3JqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 05:46:16 -0400
Received: by wibxm9 with SMTP id xm9so60795869wib.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 02:46:15 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:46:11 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 02/12] [media] dvb-pll: Add support for THOMSON DTT7546X
 tuner.
Message-ID: <20150730094611.GC488@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
 <1435158670-7195-3-git-send-email-peter.griffin@linaro.org>
 <20150722141040.2be3ca98@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150722141040.2be3ca98@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, 22 Jul 2015, Mauro Carvalho Chehab wrote:

> Em Wed, 24 Jun 2015 16:11:00 +0100
> Peter Griffin <peter.griffin@linaro.org> escreveu:
> 
> > This is used in conjunction with the STV0367 demodulator on
> > the STV0367-NIM-V1.0 NIM card which can be used with the STi
> > STB SoC's.
> > 
> > This tuner has a fifth register, so some changes have been made
> > to accommodate this.
> > 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  drivers/media/dvb-frontends/dvb-pll.c | 74 +++++++++++++++++++++++++++++------
> >  drivers/media/dvb-frontends/dvb-pll.h |  1 +
> >  2 files changed, 64 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
> > index 6d8fe88..f7381c7 100644
> > --- a/drivers/media/dvb-frontends/dvb-pll.c
> > +++ b/drivers/media/dvb-frontends/dvb-pll.c
> > @@ -141,6 +141,35 @@ static struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
> >  	},
> >  };
> >  
> > +static void thomson_dtt7546x_bw(struct dvb_frontend *fe, u8 *buf)
> > +{
> > +	/* set CB2 reg - set ATC, XTO */
> > +	buf[4] = 0xc3;
> > +}
> > +
> > +static struct dvb_pll_desc dvb_pll_thomson_dtt7546x = {
> > +	.name  = "Thomson dtt7546x",
> > +	.min   = 44250000,
> > +	.max   = 863250000,
> > +	.set   = thomson_dtt7546x_bw,
> > +	.iffreq= 36166667,
> 
> Whitespace is missing. Please check the patchs with scripts/checkpatch.pl.

Will fix in V2.

regards,

Peter.

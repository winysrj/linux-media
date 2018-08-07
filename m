Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeHGOBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 10:01:36 -0400
Date: Tue, 7 Aug 2018 08:47:33 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] media: imx: shut up a false positive warning
Message-ID: <20180807084733.7839c883@coco.lan>
In-Reply-To: <584aecdc-961a-6d64-147c-f37adaef3bcf@gmail.com>
References: <132f3c7bb98673f713be9511de16b7622803df36.1533635936.git.mchehab+samsung@kernel.org>
        <584aecdc-961a-6d64-147c-f37adaef3bcf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 7 Aug 2018 12:00:46 +0100
Ian Arkver <ian.arkver.dev@gmail.com> escreveu:

> Hi Mauro,
> 
> On 07/08/18 10:58, Mauro Carvalho Chehab wrote:
> > With imx, gcc produces a false positive warning:
> > 
> > 	drivers/staging/media/imx/imx-media-csi.c: In function 'csi_idmac_setup_channel':
> > 	drivers/staging/media/imx/imx-media-csi.c:457:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
> > 	   if (passthrough) {
> > 	      ^
> > 	drivers/staging/media/imx/imx-media-csi.c:464:2: note: here
> > 	  default:
> > 	  ^~~~~~~
> > 
> > That's because the regex it uses for fall trough is not
> > good enough. So, rearrange the fall through comment in a way
> > that gcc will recognize.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >   drivers/staging/media/imx/imx-media-csi.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index 4647206f92ca..b7ffd231c64b 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -460,7 +460,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
> >   			passthrough_cycles = incc->cycles;
> >   			break;
> >   		}
> > -		/* fallthrough for non-passthrough RGB565 (CSI-2 bus) */
> > +		/* for non-passthrough RGB565 (CSI-2 bus) */
> > +		/* Falls through */  
> 
> Adding a '-' to the fallthrough seems to meet the regex requirements at 
> level 3 of the warning. Eg...
> 
> /* fallthrough- for non-passthrough RGB565 (CSI-2 bus) */
> 
> Not sure if this is an improvement though.

Hmm... this also works:

/* fallthrough - non-passthrough RGB565 (CSI-2 bus) */

I would actually prefer a ':' instead of '-', but that works too,
and it could be better than splitting fall through messages on
two comments.

Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55342 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab2F1Jw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:52:58 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH v3 04/13] davinci: vpif: fix setting of data width in
 config_vpif_params() function
Date: Thu, 28 Jun 2012 09:52:50 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E936B16@DBDE01.ent.ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com>
 <1340622455-10419-5-git-send-email-manjunath.hadli@ti.com>
 <4FE99091.7070001@mvista.com>
In-Reply-To: <4FE99091.7070001@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Tue, Jun 26, 2012 at 16:06:01, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-06-2012 15:07, Manjunath Hadli wrote:
> 
> > fix setting of data width in config_vpif_params() function,
> > which was wrongly set.
> 
> > Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> > Signed-off-by: Lad, Prabhakar<prabhakar.lad@ti.com>
> > ---
> >   drivers/media/video/davinci/vpif.c |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> > diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
> > index 774bcd3..08fb81f 100644
> > --- a/drivers/media/video/davinci/vpif.c
> > +++ b/drivers/media/video/davinci/vpif.c
> > @@ -346,7 +346,7 @@ static void config_vpif_params(struct vpif_params *vpifparams,
> >
> >   			value = regr(reg);
> >   			/* Set data width */
> > -			value&= ((~(unsigned int)(0x3))<<
> > +			value&= ~(((unsigned int)(0x3))<<
> 
>     Why not just 0x3u instead of (unsigned int)(0x3)?
> 
      Ok.

Thx,
--Manju

> WBR, Sergei
> 


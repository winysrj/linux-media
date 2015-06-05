Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58689 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422789AbbFEPl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 11:41:57 -0400
Date: Fri, 5 Jun 2015 12:41:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] vivid: don't use more than 1024 bytes of stack
Message-ID: <20150605124152.6a721c9d@recife.lan>
In-Reply-To: <5571BBFD.6070902@xs4all.nl>
References: <9b65bac2413275a234ab904bedd08fdc4b03845e.1433500152.git.mchehab@osg.samsung.com>
	<5571BBFD.6070902@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 05 Jun 2015 17:10:53 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/05/2015 12:29 PM, Mauro Carvalho Chehab wrote:
> > Remove the following compilation warnings:
> > 
> > 	drivers/media/platform/vivid/vivid-tpg.c: In function 'tpg_gen_text':
> > 	drivers/media/platform/vivid/vivid-tpg.c:1562:1: warning: the frame size of 1308 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > 	 }
> > 	 ^
> > 
> > This seems to be due to some bad optimization done by gcc.
> > 
> > Moving the for() loop to happen inside the macro solves the
> > issue.
> > 
> > While here, fix CodingStyle at the switch().
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
> > index b1147f2df26c..7a3ed580626a 100644
> > --- a/drivers/media/platform/vivid/vivid-tpg.c
> > +++ b/drivers/media/platform/vivid/vivid-tpg.c
> > @@ -1492,12 +1492,10 @@ void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
> >  	else if (tpg->field == V4L2_FIELD_SEQ_TB || tpg->field == V4L2_FIELD_SEQ_BT)
> >  		div = 2;
> >  
> > -	for (p = 0; p < tpg->planes; p++) {
> > -		unsigned vdiv = tpg->vdownsampling[p];
> > -		unsigned hdiv = tpg->hdownsampling[p];
> > -
> > -		/* Print text */
> > -#define PRINTSTR(PIXTYPE) do {	\
> > +	/* Print text */
> > +#define PRINTSTR(PIXTYPE) for (p = 0; p < tpg->planes; p++) {	\
> > +	unsigned vdiv = tpg->vdownsampling[p];	\
> > +	unsigned hdiv = tpg->hdownsampling[p];	\
> >  	PIXTYPE fg;	\
> >  	PIXTYPE bg;	\
> >  	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
> > @@ -1548,16 +1546,19 @@ void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
> >  	}	\
> >  } while (0)
> >  
> > -		switch (tpg->twopixelsize[p]) {
> > -		case 2:
> > -			PRINTSTR(u8); break;
> > -		case 4:
> > -			PRINTSTR(u16); break;
> > -		case 6:
> > -			PRINTSTR(x24); break;
> > -		case 8:
> > -			PRINTSTR(u32); break;
> > -		}
> > +	switch (tpg->twopixelsize[p]) {
> 
> This doesn't work I just discovered. Compiling gives this warning:
> 
> drivers/media/platform/vivid/vivid-tpg.c: In function ‘tpg_gen_text’:
> drivers/media/platform/vivid/vivid-tpg.c:1549:27: warning: ‘p’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   switch (tpg->twopixelsize[p]) {
>                            ^
> 

Weird. here (gcc 5.1.1) I didn't get any warning.

> And the value for tpg->twopixelsize[p] will actually differ depending on the value of p.
> 
> It's probably best to revert this patch.
> 
> The correct approach is likely to make four functions, one for case,
> with the macro as the function body.

I tried that (without the for). The result was worse.

I'll double check it latter today.

> 
> Regards,
> 
> 	Hans
> 
> > +	case 2:
> > +		PRINTSTR(u8);
> > +		break;
> > +	case 4:
> > +		PRINTSTR(u16);
> > +		break;
> > +	case 6:
> > +		PRINTSTR(x24);
> > +		break;
> > +	case 8:
> > +		PRINTSTR(u32);
> > +		break;
> >  	}
> >  }
> >  
> > 
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43568 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbaKEMlq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 07:41:46 -0500
Date: Wed, 5 Nov 2014 10:41:41 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/5] [media] cx24110: Fix a spatch warning
Message-ID: <20141105104141.542f6d4a@recife.lan>
In-Reply-To: <545A164B.2010908@xs4all.nl>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
	<b8e64df00231a4c4d59b68d8eda9f8db1adc1ea4.1415188985.git.mchehab@osg.samsung.com>
	<545A164B.2010908@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 05 Nov 2014 13:21:31 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> spatch or smatch? I assume smatch :-)

Yeah, typo... both are tools used for static code analizers... very easy to
type it wrong ;)

> 
> BTW, I've just added smatch support to the daily build.

Good!

I'll fix some more smatch errors today. There are some false positives
there, but some seems to be real issues.
> 
> Regards,
> 
> 	Hans
> 
> On 11/05/14 13:03, Mauro Carvalho Chehab wrote:
> > This is actually a false positive:
> > 	drivers/media/dvb-frontends/cx24110.c:210 cx24110_set_fec() error: buffer overflow 'rate' 7 <= 8
> > 
> > But fixing it is easy: just ensure that the table size will be
> > limited to FEC_AUTO.
> > 
> > While here, fix spacing on the affected lines.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
> > index 95b981cd7115..e78e7893e8aa 100644
> > --- a/drivers/media/dvb-frontends/cx24110.c
> > +++ b/drivers/media/dvb-frontends/cx24110.c
> > @@ -181,16 +181,16 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
> >  {
> >  /* fixme (low): error handling */
> >  
> > -	static const int rate[]={-1,1,2,3,5,7,-1};
> > -	static const int g1[]={-1,0x01,0x02,0x05,0x15,0x45,-1};
> > -	static const int g2[]={-1,0x01,0x03,0x06,0x1a,0x7a,-1};
> > +	static const int rate[FEC_AUTO] = {-1,    1,    2,    3,    5,    7, -1};
> > +	static const int g1[FEC_AUTO]   = {-1, 0x01, 0x02, 0x05, 0x15, 0x45, -1};
> > +	static const int g2[FEC_AUTO]   = {-1, 0x01, 0x03, 0x06, 0x1a, 0x7a, -1};
> >  
> >  	/* Well, the AutoAcq engine of the cx24106 and 24110 automatically
> >  	   searches all enabled viterbi rates, and can handle non-standard
> >  	   rates as well. */
> >  
> > -	if (fec>FEC_AUTO)
> > -		fec=FEC_AUTO;
> > +	if (fec > FEC_AUTO)
> > +		fec = FEC_AUTO;
> >  
> >  	if (fec==FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
> >  		cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)&0xdf);
> > 
> 

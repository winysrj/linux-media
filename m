Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60959 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbbETIjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 04:39:42 -0400
Date: Wed, 20 May 2015 05:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Federico Simoncelli <fsimonce@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Buesch <m@bues.ch>, Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takashi Iwai <tiwai@suse.de>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2] drivers: Simplify the return code
Message-ID: <20150520053929.4c151fae@recife.lan>
In-Reply-To: <577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
	<0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
	<a24b23db60ffee5cb32403d7c8cacd25b13f4510.1432033220.git.mchehab@osg.samsung.com>
	<577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2015 08:05:56 -0400 (EDT)
Federico Simoncelli <fsimonce@redhat.com> escreveu:

> ----- Original Message -----
> > From: "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
> > To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
> > Cc: "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>, "Mauro Carvalho Chehab" <mchehab@infradead.org>, "Lars-Peter
> > Clausen" <lars@metafoo.de>, "Michael Buesch" <m@bues.ch>, "Antti Palosaari" <crope@iki.fi>, "Hans Verkuil"
> > <hverkuil@xs4all.nl>, "Sakari Ailus" <sakari.ailus@linux.intel.com>, "Ondrej Zary" <linux@rainbow-software.org>,
> > "Ramakrishnan Muthukrishnan" <ramakrmu@cisco.com>, "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>, "Takashi
> > Iwai" <tiwai@suse.de>, "Amber Thrall" <amber.rose.thrall@gmail.com>, "Federico Simoncelli" <fsimonce@redhat.com>,
> > "James Harper" <james.harper@ejbdigital.com.au>, "Dan Carpenter" <dan.carpenter@oracle.com>, "Konrad Rzeszutek Wilk"
> > <konrad.wilk@oracle.com>
> > Sent: Tuesday, May 19, 2015 1:00:57 PM
> > Subject: [PATCH 2/2] drivers: Simplify the return code
> > 
> > If the last thing we do in a function is to call another
> > function and then return its value, we don't need to store
> > the returned code into some ancillary var.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/dvb-frontends/lgs8gxx.c
> > b/drivers/media/dvb-frontends/lgs8gxx.c
> > index 3c92f36ea5c7..9b0166cdc7c2 100644
> > --- a/drivers/media/dvb-frontends/lgs8gxx.c
> > +++ b/drivers/media/dvb-frontends/lgs8gxx.c
> > @@ -544,11 +544,7 @@ static int lgs8gxx_set_mpeg_mode(struct lgs8gxx_state
> > *priv,
> >  	t |= clk_pol ? TS_CLK_INVERTED : TS_CLK_NORMAL;
> >  	t |= clk_gated ? TS_CLK_GATED : TS_CLK_FREERUN;
> >  
> > -	ret = lgs8gxx_write_reg(priv, reg_addr, t);
> > -	if (ret != 0)
> > -		return ret;
> > -
> > -	return 0;
> > +	return lgs8gxx_write_reg(priv, reg_addr, t);
> >  }
> 
> Personally I prefer the current style because it's more consistent with all
> the other calls in the same function (return ret when ret != 0).
> 
> It also allows you to easily add/remove calls without having to deal with
> the last special case return my_last_fun_call(...).
> 
> Anyway it's not a big deal, I think it's your call.

First of all, I wrote this patch to test coccinelle (with was broken
in Fedora 21 due to a dependency issue[1]). Once done, why not submit?
So, it is not that I'm really wanting to do that.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1218987

Yet, as someone that review a lot of code, the above is a way better,
as I can instantly check that the data returned by lgs8gxx_write_reg()
will also be returned to the caller function. Ok, this optimizes a few
milliseconds of my brain's processing, but it still means a faster
review to me, with is a gain, as I spend big periods of time reviewing
code. So, the simpler, the merrier.

Also, I don't trust too much on compiler optimization. I mean: I don't
expect that gcc will always do the right thing and remove the useless
if. Writing software for so long time, I know that software has bugs.
So, if I see something that can be easily optimized like the above
code, I do. It is one less thing to trust that the compiler will do
right.

Regards,
Mauro


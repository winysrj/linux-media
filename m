Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753230AbZBFLrc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Feb 2009 06:47:32 -0500
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	gimli@dark-green.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 06 Feb 2009 12:47:30 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <1233904445.1916.139.camel@tux.localhost>
Message-ID: <20090206114730.41740@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>	
 <4935B72F.1000505@insite.cz>	
 <c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	
 <c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>	
 <49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>	
 <c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>	
 <20081206170753.69410@gmx.net> <20081209153451.75130@gmx.net>	
 <20081215143047.45940@gmx.net> <20090104192435.72460@gmx.net>	
 <59327.62.178.208.71.1231173948.squirrel@webmail.dark-green.com>	
 <20090105173606.271160@gmx.net>	
 <40866.62.178.208.71.1231178997.squirrel@webmail.dark-green.com>	
 <20090205123431.29950@gmx.net> <1233904445.1916.139.camel@tux.localhost>
Subject: Re: [PATCH] Mantis Bug (was Technisat HD2 cannot szap/scan)
To: Alexey Klimov <klimov.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> Hello,
> i'm sorry to bother you with this small thing.
>
> 
> On Thu, 2009-02-05 at 13:34 +0100, Hans Werner wrote:

> > 
> > I looked at it again and here is a new patch to set the LNBP21 
> > options for the Twinhan VP-1041. This works better for me, including
> > DVB-S2 channels. The EN enable bit is now not permanently set so
> > sleep behavior is correct.
> > 
> > Please note that I have a DiSEqC 1.2 rotor between the VP-1041 card
> > and the LNB. That is quite a normal configuration, but the driver was
> > probably not properly tested with rotors (and switches?) before.
> > 
> > To rotate with scan-s2 use the patch I posted, which will be applied
> > there soon:
> > http://linuxtv.org/pipermail/linux-dvb/2009-January/031660.html
> > 
> > Regards,
> > Hans
> > 
> > Patch is against latest
> http://mercurial.intuxication.org/hg/s2-liplianin  repo.
> > 
> > Signed-off-by: Hans Werner <hwerner4@gmx.de>
> >  
> > diff -r 084878324629 linux/drivers/media/dvb/mantis/mantis_dvb.c
> > --- a/linux/drivers/media/dvb/mantis/mantis_dvb.c
> > +++ b/linux/drivers/media/dvb/mantis/mantis_dvb.c
> > @@ -239,7 +239,8 @@ int __devinit mantis_frontend_init(struc
> >  			vp1041_config.demod_address);
> >  
> >  			if (stb6100_attach(mantis->fe, &vp1041_stb6100_config,
> &mantis->adapter)) {
> > -				if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0, 0)) {
> > +				// static current limit, no extra 1V, high current limit, tone from
> DSQIN pin (stb0899)
> 
> May i ask you not to use C99-style "// ..." comments ?
> Linux style for comments is the C89 "/* ... */" style.
> 
> Honestly, when you do "make checkpatch" it will notify you about bad
> things (style of comments included).

Thanks for pointing it out -- I appreciate your attention to detail.
However a quick grep of the kernel source shows that there are
thousands of // comments already.

Surely both styles are allowed now?

Regards,
Hans

> 
> 
> > +				if (!lnbp21_attach(mantis->fe, &mantis->adapter, LNBP21_PCL ,
> LNBP21_LLC | LNBP21_ISEL | LNBP21_TEN)) {
> >  					printk("%s: No LNBP21 found!\n", __FUNCTION__);
> >  					mantis->fe = NULL;
> >  				}
> > 
> -- 
> Best regards, Klimov Alexey

-- 
Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01

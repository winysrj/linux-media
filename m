Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575Ab3CHSJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 13:09:33 -0500
Date: Fri, 8 Mar 2013 19:09:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: mt9m111/mt9m131: kernel 3.8 issues.
In-Reply-To: <1700189562.356790.1362748660082.JavaMail.root@advansee.com>
Message-ID: <Pine.LNX.4.64.1303081903250.24912@axis700.grange>
References: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
 <962516300.332041.1362658383433.JavaMail.root@advansee.com>
 <CACKLOr2VOb3GMiX6GVmSchhGs8XeBJ0c7qRSHZwU8e8C+qeWPg@mail.gmail.com>
 <1201392585.355417.1362743602969.JavaMail.root@advansee.com>
 <CACKLOr0FEO3wvpZpn=Fg9ZSBYLDnY-hY=KysD72JVbrcVChArg@mail.gmail.com>
 <1700189562.356790.1362748660082.JavaMail.root@advansee.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 8 Mar 2013, Benoît Thébaudeau wrote:

> Hi Javier,
> 
> On Friday, March 8, 2013 1:37:38 PM, Javier Martin wrote:
> > Hi Benoît,
> > 
> > On 8 March 2013 12:53, Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> > wrote:
> > >
> > >> Regarding 3, you say it works nicely for you in kernel 3.4.5. I've
> > >> migrated my code to that version but I still get colours that lack
> > >> enough intensity.
> > >> This is a snapshot "a" taken with my mobile which is much more similar
> > >> to what I can really see with my eyes:
> > >> http://img96.imageshack.us/img96/1451/20130307171334.jpg
> > >>
> > >> This is a similar snapshot "b" taken with mt9m131 in my board. It
> > >> shows that colours tend to be dull and darker, specially green:
> > >> http://img703.imageshack.us/img703/6025/testgo.jpg
> > >>
> > >> Are the snapshots you take with your HW  more similar to "a" or to
> > >> "b"? Perhaps I am being too picky with the image quality and this is
> > >> all what mt9m131 can do?
> > >
> > > I fear that my captures are closer to "b". Your description of "3" was
> > > giving
> > > the impression of flashy colors. But the impression that this sensor gives
> > > me is
> > > rather a superimposed gray film. This effect is more or less visible
> > > depending
> > > on the lighting conditions, but it never seems to produce high quality
> > > colors.
> > 
> > Yes, yours is probably is the best description for the image quality
> > this sensor provides with the current settings.
> > Well, this is a bit disappointing. Let's see if some other user has a
> > similar experience with it or comes up with a way to improve it.
> > 
> > I've tested several things such as disabling auto white balance and
> > auto exposure and try to manually change colour gains but it seems the
> > sensor simply ignores the latter.
> > 
> > There is an evaluation board  from Aptina
> > (http://www.digikey.com/product-detail/es/MT9M131C12STCH%20ES/557-1251-ND/1643271)
> > but, unfortunately, I don't have one of these available. It could be
> > very useful to test the sensor with this board with the configuration
> > Aptina recommends and see whether the "grey layer effect" still
> > persists.
> 
> It is perhaps also possible to find their recommended register settings
> somewhere without having this evaluation board.

I just tested my mt9m131 camera on a i.MX31 board, if not this your email 
I don't think I'd be alarmed by the image quality it's producing, maybe 
I'm just less picky:-) And yes, in general I agree, I think, this level of 
image quality tuning is difficult to achieve on modern cameras with 100s 
of fine-tuning knobs. I'll try to re-test this camera in day light 
conditions and post my best shot :)

Thanks
Guennadi

> > I will try to contact Aptina's technical support but, according to my
> > previous experience, there is no guarantee we get a clarifying answer.
> > I'll keep you updated nevertheless.
> 
> Thanks.
> 
> Best regards,
> Benoît
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753005AbZIGMJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 08:09:54 -0400
Date: Mon, 7 Sep 2009 14:10:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
In-Reply-To: <200909071353.43080.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909071407530.6597@axis700.grange>
References: <200908031031.00676.marek.vasut@gmail.com>
 <200909071050.11531.marek.vasut@gmail.com> <m2iqfvkqbl.fsf@arbois.toulouse.it.atosorigin.com>
 <200909071353.43080.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 7 Sep 2009, Marek Vasut wrote:

> Dne Po 7. září 2009 12:21:50 Robert Jarzmik napsal(a):
> > Marek Vasut <marek.vasut@gmail.com> writes:
> > > How's it supposed to get BGR555 if the pxa-camera doesnt support that ?
> > > Will the v4l2 layer convert it or something ?
> >
> > In pxa_camera.c, function pxa_camera_get_formats() :
> > >         default:
> > >                 /* Generic pass-through */
> > >                 formats++;
> > >                 if (xlate) {
> > >                         xlate->host_fmt = icd->formats + idx;
> > >                         xlate->cam_fmt = icd->formats + idx;
> > >                         xlate->buswidth = icd->formats[idx].depth;
> > >                         xlate++;
> > >                         dev_dbg(ici->dev,
> > >                                 "Providing format %s in pass-through
> > > mode\n", icd->formats[idx].name);
> > >                 }
> > >         }
> >
> > "Pass-through" means that if a sensors provides a cc, ie. BGR555 for
> > example, the bridge (pxa_camera) will "forward" to RAM the image in the
> > very same cc (ie. BGR555). In that case, the bridge is a dummy "sensor to
> > RAM" bus translator if you prefer.
> >
> > Marek, you should activate debug trace and watch for yourself. You can
> > trust Guennadi, when he says it will work, well ... it will work.
> >
> > If it's out of technical curiousity, check the function above.  If you're
> > even more curious, there was a thread in linux-media about "RFC: bus
> > configuration setup for sub-devices", a very interesting one, especially
> > considering the "pass-through" issue.
> 
> That one should work for RGB565X ? (the piece of code you posted ?) It's 
> interesting it didnt work for me ... ok, I'll take it it works then, whatever. 
> I'll test it again when I have time.

No, that one cannot work with rgb565x or any other format, not supported 
by pxa directly and not complying to bus-width = bit-depth. But it will 
work with the new imagebus API. Either see my explanations in a previous 
mail, or check the patches I posted recently to the list.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

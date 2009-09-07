Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44047 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZIGLyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 07:54:07 -0400
Received: by fxm17 with SMTP id 17so1931056fxm.37
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 04:54:08 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
Date: Mon, 7 Sep 2009 13:53:42 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	"Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
References: <200908031031.00676.marek.vasut@gmail.com> <200909071050.11531.marek.vasut@gmail.com> <m2iqfvkqbl.fsf@arbois.toulouse.it.atosorigin.com>
In-Reply-To: <m2iqfvkqbl.fsf@arbois.toulouse.it.atosorigin.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909071353.43080.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Po 7. září 2009 12:21:50 Robert Jarzmik napsal(a):
> Marek Vasut <marek.vasut@gmail.com> writes:
> > How's it supposed to get BGR555 if the pxa-camera doesnt support that ?
> > Will the v4l2 layer convert it or something ?
>
> In pxa_camera.c, function pxa_camera_get_formats() :
> >         default:
> >                 /* Generic pass-through */
> >                 formats++;
> >                 if (xlate) {
> >                         xlate->host_fmt = icd->formats + idx;
> >                         xlate->cam_fmt = icd->formats + idx;
> >                         xlate->buswidth = icd->formats[idx].depth;
> >                         xlate++;
> >                         dev_dbg(ici->dev,
> >                                 "Providing format %s in pass-through
> > mode\n", icd->formats[idx].name);
> >                 }
> >         }
>
> "Pass-through" means that if a sensors provides a cc, ie. BGR555 for
> example, the bridge (pxa_camera) will "forward" to RAM the image in the
> very same cc (ie. BGR555). In that case, the bridge is a dummy "sensor to
> RAM" bus translator if you prefer.
>
> Marek, you should activate debug trace and watch for yourself. You can
> trust Guennadi, when he says it will work, well ... it will work.
>
> If it's out of technical curiousity, check the function above.  If you're
> even more curious, there was a thread in linux-media about "RFC: bus
> configuration setup for sub-devices", a very interesting one, especially
> considering the "pass-through" issue.

That one should work for RGB565X ? (the piece of code you posted ?) It's 
interesting it didnt work for me ... ok, I'll take it it works then, whatever. 
I'll test it again when I have time.
>
> Cheers.
>
> --
> Robert

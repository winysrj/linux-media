Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm12-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.142]:43519 "HELO
	nm12-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751008Ab1GSBqE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 21:46:04 -0400
Message-ID: <1311039554.88024.YahooMailClassic@web121815.mail.ne1.yahoo.com>
Date: Mon, 18 Jul 2011 18:39:14 -0700 (PDT)
From: Luiz Ramos <lramos.prof@yahoo.com.br>
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110715194448.401bf441@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Jean-François,

I downloaded the tarball you recommended, compiled it and it works nicely.

The original problem also happened with this package. Playing around
with reg17 at some points, and looking the code before the commit of 2010-12-21, I could manage to work around the problem.

Only to remember, in kernel version 2.6.37.6 the webcam became very dark (I could only see things like a 60 W incandescent lamp, one meter long, or things like clear blue sky). It seemed there was some problems with auto-exposure, auto-gain or other similar.

However, the difference which effectively changed the things is the value which reg17 carries after line 2535 of gspca_sonixj.c (now referring to the "tarball" code).

I noticed that in 640x480 the device worked fine, but in 320x240 and 160x120 it didn't (I mean: the image is dark). Or'ing reg17 with 0x04 in line 2535 (as it's currently done for VGA) is sufficient to make the webcam work again. The change could be like that:

diff --git a/build/sonixj.c b/build/sonixj.c
index afde673..802dbfa 100644
--- a/build/sonixj.c
+++ b/build/sonixj.c
@@ -2532,6 +2532,10 @@ static int sd_start(struct gspca_dev *gspca_dev)
                        reg17 &= ~MCK_SIZE_MASK;
                        reg17 |= 0x04;          /* clock / 4 */
                }
+               else {                          /* if 320x240 || 160x120 */
+                       reg17 &= ~MCK_SIZE_MASK;
+                       reg17 |= 0x04;
+               }
                break;
        case SENSOR_OV7630:
                init = ov7630_sensor_param1;

However, the frame rates get limited to 10 fps. Without that change, and in 320x240 and 160x120, they reach 20 fps (of darkness).

I can't see what or'ing that register means, and what's the relationship between this and the webcam darkness. It seems that these bits control some kind of clock; this can be read in the program comments. One other argument in favour of this assumption is the fact that the frame rate changes accordingly to the value of these bits. But I can't see how this relates to exposure.

For my purposes, I'll stay with that change; it's sufficient for my purposes. If you know what I did, please advise me. :-)

Thanks for your help,

Luiz




--- Em sex, 15/7/11, Jean-Francois Moine <moinejf@free.fr> escreveu:

> De: Jean-Francois Moine <moinejf@free.fr>
> Assunto: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
> Para: "Luiz Ramos" <lramos.prof@yahoo.com.br>
> Cc: linux-media@vger.kernel.org
> Data: Sexta-feira, 15 de Julho de 2011, 14:44
> On Fri, 15 Jul 2011 02:57:43 -0700
> (PDT)
> Luiz Ramos <lramos.prof@yahoo.com.br>
> wrote:
> 
> > Ok, I'm now grabbing this tarball:
> > http://moinejf.free.fr/gspca-2.13.2.tar.gz.
> > 
> > The site also features a (some) git repository(ies)
> but I understood
> > you mean the test version, is it right?
> 
> Yes. The tarball is simpler to compile and install.
> 
> -- 
> Ken ar c'hentañ    |   
>       ** Breizh ha Linux atav! **
> Jef       
> |        http://moinejf.free.fr/
> 

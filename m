Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Igor <goga777@bk.ru>
To: VDR Mailing List <vdr@linuxtv.org>
Mime-Version: 1.0
Date: Sat, 03 May 2008 22:51:26 +0400
In-Reply-To: <20080502164053.GA6397@gmail.com>
References: <20080502164053.GA6397@gmail.com>
Message-Id: <E1JsMpS-0000xG-00.goga777-bk-ru@f111.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?W3Zkcl0gVkRSIDEuNy4wICYgbXVsdGlwcm90byAm?=
	=?koi8-r?b?IGh2cjQwMDAgLT4gbXVsdGlwcm90b19wbHVz?=
Reply-To: Igor <goga777@bk.ru>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> > > Have you replaced linux/include/linux/compiler.h with the one from your
> > > kernel ? (in multiproto_plus dir) if that's going to be included, this
> > > shouldn't be in of course.
> > 
> > your patch included the compiler.h, after replacing it with the right
> > one the drivers are build
> > your patch also created a .config.old in v4l and the cx88 modules are
> > not build (the .config created during make does only contain inaktive
> > lines for cx88 modules), i modified the .config manual and started make
> > again
> 
> OK, here's one without compiler.h and without .config.old (by the way, I
> don't understand why make distclean didn't remove it...).
> 
> Good new, such way the patch is even smaller, so it would be really good
> to have it included finally into the repo :-)
> 
> Any objection to the inclusion ?

with this patch I have the error

May  3 22:42:15 localhost vdr: [3471] ERROR (dvbdevice.c,302): Invalid argument

when I try to tune on dvb-s2 channels on VDR

But with HVR-4000-multiproto_plus-2008-04-25.diff + "HVR-4000-multiproto_plus-2008-04-25_inversion" is OK for me

Igor








_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

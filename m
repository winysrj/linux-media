Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KhbHV-0005gK-EK
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 04:36:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7K00ADXSJAMN80@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 21 Sep 2008 22:35:35 -0400 (EDT)
Date: Sun, 21 Sep 2008 22:35:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <c64bf6860809211533p7ee768b0j9b36a3ee954034fd@mail.gmail.com>
To: Tharsan Bhuvanendran <me@tharsan.com>
Message-id: <48D70476.5040702@linuxtv.org>
MIME-version: 1.0
References: <c64bf6860809200004o1970a939jaa51e543de2ec594@mail.gmail.com>
	<412bdbff0809200729q551ece09u98fb2c22f680188b@mail.gmail.com>
	<c64bf6860809211533p7ee768b0j9b36a3ee954034fd@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Pinnacle PCTV mini stick (USB TV Tuner)
	80e
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

Tharsan Bhuvanendran wrote:
> Devin,
> 
> Thanks for the quick response!
> 
> I've pried open the device and snapped a few shots with my Nikon D40.  
> You can get them at http://drop.io/tharsan.
> 
> I also created a Wiki page for the device at 
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_mini_Stick_(80e).
> I've documented what I could determine on the Wiki page.
> 
> Please let me know if there's anything else you need and I'll do my very 
> best to get you what you need!

Please don't top post, it's against the list policy. More below.

> 
> - Tharsan
> 
> On Sat, Sep 20, 2008 at 10:29 AM, Devin Heitmueller 
> <devin.heitmueller@gmail.com <mailto:devin.heitmueller@gmail.com>> wrote:
> 
>     Hello Tharsan,
> 
>     2008/9/20 Tharsan Bhuvanendran <me@tharsan.com <mailto:me@tharsan.com>>:
>      > Hi,
>      >
>      > At the moment, there doesn't seem to be any dvb support for the
>     Pinnacle
>      > PCTV HD mini stick (USB TV Tuner).
>      > The model is 80e.  This appears to be a new model, released about
>     a month
>      > ago.
>      >
>      > The Pinnacle product page is here:
>      >
>     http://pinnaclesys.com/PublicSite/us/Products/Consumer+Products/PCTV+Tuners/PCTV+Digital+PVR+(DVB-S_DVB-T)/HD+mini+Stick
>     <http://pinnaclesys.com/PublicSite/us/Products/Consumer+Products/PCTV+Tuners/PCTV+Digital+PVR+%28DVB-S_DVB-T%29/HD+mini+Stick>
> 
>     I just finished support for the Pro and Non-Pro versions a couple of
>     weeks ago, but judging by the different form factor, I would suspect
>     this is a different hardware design.
> 
>     The most useful thing you could do would be to pop the device open and
>     take digital photos of the PCBs, and create a page on the LInuxTV DVB
>     Wiki for the device.
> 
>     Once we know what components it contains, that will give us some idea
>     how much work will be required.
> 
>     Regards,
> 
>     Devin

We have inkernel support for the TDA18271 but not the DRXJ demo I think.

Please add the pictures to the wiki so they don't get lost, and other 
users can benefit from them 12 months form now without having to 
reference this email.

Thanks,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

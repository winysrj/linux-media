Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JzaYj-00051x-Ur
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 18:56:04 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id C417419E673A
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 20:55:27 +0400 (MSD)
Received: from localhost.localdomain (unknown [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 7866A19E6738
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 20:55:27 +0400 (MSD)
Date: Fri, 23 May 2008 20:58:19 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080523205819.6eafe5fa@bk.ru>
In-Reply-To: <854d46170805230936n4b48ae3dy50fb86780eded5d4@mail.gmail.com>
References: <4836DBC1.5000608@gmail.com> <4836E28B.5000405@linuxtv.org>
	<4836E4E3.70405@gmail.com>
	<854d46170805230936n4b48ae3dy50fb86780eded5d4@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
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

> >>> The attached adds support for using multiproto drivers with the old api.
> >>
> >> there seems to be a needlessly duplicated line in your patch:
> >>
> >> +     /* set delivery system to the default old-API one */
> >> +     if (fe->ops.set_delsys) {
> >> +             switch(fe->ops.info.type) {
> >> +             case FE_QPSK:
> >> +                     fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
> >> +                     fe->ops.set_delsys(fe, DVBFE_DELSYS_DVBS);
> >
> > Strange, the latter one should be 'break;'.
> >
> > Attached again.
> >
> > --
> > Anssi Hannula
> 
> Thank you so much :)
> I can't believe I'm watching tv in kaffeine with my multiproto card.

what about dvb-s2 channels on your kaffeine ? how can you watch their ?

Goga
 
> My card is Technotred TT Connect S2-3650 CI
> Using this drivers:
> dvb-core.ko
> dvb-pll.ko
> stb6100.ko
> insmod stb0899.ko
> lnbp22.ko
> idvb-usb.ko
> dvb-usb-pctv452e.ko


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

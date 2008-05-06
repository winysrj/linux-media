Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f97.mail.ru ([194.67.57.7])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JtQNM-00069K-NF
	for linux-dvb@linuxtv.org; Tue, 06 May 2008 18:50:51 +0200
From: Igor <goga777@bk.ru>
To: Gernot Pansy <pansyg@gmx.at>
Mime-Version: 1.0
Date: Tue, 06 May 2008 20:50:07 +0400
In-Reply-To: <200805051543.59551.pansyg@gmx.at>
References: <200805051543.59551.pansyg@gmx.at>
Message-Id: <E1JtQMh-0008O0-00.goga777-bk-ru@f97.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?e1NQQU0gMDUuNH0gUmVbMl06ICBQQVRDSDogSFZS?=
	=?koi8-r?b?LTQwMDAgc3VwcG9ydCBmb3IgbXVsdGlwcm90b19wbHVzCSh0ZXN0?=
	=?koi8-r?b?ZWRvbiAyLjYuMjUp?=
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

Hi

thank you - your patch is working to me. But I can't use it long because  I use the vdr 170 with multiproto api support. May be you can create the patch for szap2 with multiproto api support :)

Igor


-----Original Message-----
From: Gernot Pansy <pansyg@gmx.at>
To: Igor <goga777@bk.ru>
Date: Mon, 5 May 2008 15:43:59 +0200
Subject: Re: {SPAM 05.4} Re[2]: [linux-dvb] PATCH: HVR-4000 support for multiproto_plus	(testedon 2.6.25)

> 
> On Monday 05 May 2008 15:14:24 Igor wrote:
> > > On Friday 25 April 2008 09:07:13 Igor wrote:
> > > > Hi, Gregoire
> > > >
> > > > with multiproto_plus + your hvr4000-patch I have the same problem with
> > > > szap2 from dvb-apps
> > > >
> > > > ./szap2 -c 19 -n1
> > > >
> > > > reading channels from file '19'
> > > > zapping to 1 'Pro7':
> > > > sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff,
> > > > apid = 0x0103 sid = 0x27d8 Querying info .. Delivery system=DVB-S
> > > > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > > > ioctl DVBFE_GET_INFO failed: Operation not supported
> > >
> > > the patch changes the api...
> >
> > which patch do yuo mean ?
> 
> the patch from gregoire. it modifies dvb/frontend.h
> 
> >
> > > you can try the attached patch, which not changes the api. that means
> > > szap2 is working (only DVB-S, for DVB-S2 you need to modify fe_params:
> > > DVB_FEC_AUTO is not supported and you have to define a modulation)
> > >
> > > fe_params.delsys.dvbs2.fec = DVBFE_FEC_9_10;
> > > fe_params.delsys.dvbs2.modulation = DVBFE_MOD_QPSK;
> > >
> > > with the attached patch you need to call DVB_SET_DELSYS (like in
> > > szap2)...
> >
> > could you explain me - how is it possible to modify fe_params for dvb-s2
> > QPSK/8PSK reception ?
> 
> in szap2? 
> 
> --- /root/dvb-apps/test/szap2.c 2008-05-01 00:40:50.048558456 +0200
> +++ szap.c      2008-05-01 14:25:16.409871814 +0200
> @@ -269,7 +269,8 @@
>                         break;
>                 case DVBS2:
>                         fe_params.delsys.dvbs2.symbol_rate = sr;
> -                       fe_params.delsys.dvbs2.fec = FEC_AUTO;
> +                       fe_params.delsys.dvbs2.fec = DVBFE_FEC_9_10;
> +                       fe_params.delsys.dvbs2.modulation = DVBFE_MOD_QPSK;
>                         printf("%s: Frequency = %d, Srate = %d\n",
>                                 __func__, fe_params.frequency, 
> fe_params.delsys.dvbs2.symbol_rate);
>                         break;
> 
> 
> perhaps you have to set a different fec or modulation (DVBFE_MOD_8PSK);
> 
> gernot
> 
> >
> > Igor
> 
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

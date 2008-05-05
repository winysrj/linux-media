Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f190.mail.ru ([194.67.57.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1Jt0Ww-0002mA-2T
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 15:14:58 +0200
From: Igor <goga777@bk.ru>
To: Gernot Pansy <pansyg@gmx.at>
Mime-Version: 1.0
Date: Mon, 05 May 2008 17:14:24 +0400
References: <200805011536.57312.pansyg@gmx.at>
In-Reply-To: <200805011536.57312.pansyg@gmx.at>
Message-Id: <E1Jt0WO-000Hso-00.goga777-bk-ru@f190.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?UEFUQ0g6IEhWUi00MDAwIHN1cHBvcnQgZm9yIG11?=
	=?koi8-r?b?bHRpcHJvdG9fcGx1cwkodGVzdGVkb24gMi42LjI1KQ==?=
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

> On Friday 25 April 2008 09:07:13 Igor wrote:
> > Hi, Gregoire
> >
> > with multiproto_plus + your hvr4000-patch I have the same problem with
> > szap2 from dvb-apps
> >
> > ./szap2 -c 19 -n1
> >
> > reading channels from file '19'
> > zapping to 1 'Pro7':
> > sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid =
> > 0x0103 sid = 0x27d8 Querying info .. Delivery system=DVB-S
> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > ioctl DVBFE_GET_INFO failed: Operation not supported
> 
> the patch changes the api...

which patch do yuo mean ?


> you can try the attached patch, which not changes the api. that means szap2 is 
> working (only DVB-S, for DVB-S2 you need to modify fe_params: DVB_FEC_AUTO is 
> not supported and you have to define a modulation) 
> 
> fe_params.delsys.dvbs2.fec = DVBFE_FEC_9_10;
> fe_params.delsys.dvbs2.modulation = DVBFE_MOD_QPSK;
> 
> with the attached patch you need to call DVB_SET_DELSYS (like in szap2)...          

could you explain me - how is it possible to modify fe_params for dvb-s2 QPSK/8PSK reception ?

Igor

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

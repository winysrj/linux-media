Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f135.mail.ru ([194.67.57.116])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JpIE0-0006uL-Cg
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 09:20:06 +0200
From: Igor <goga777@bk.ru>
To: Faruk A <fa@elwak.com>
Mime-Version: 1.0
Date: Fri, 25 Apr 2008 11:19:30 +0400
References: <854d46170804241352o5b221ddfldfe040202acb512d@mail.gmail.com>
In-Reply-To: <854d46170804241352o5b221ddfldfe040202acb512d@mail.gmail.com>
Message-Id: <E1JpIDS-000BOD-00.goga777-bk-ru@f135.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SFZSNDAwMCAmIHN6YXAyIC0gaW9jdGwgRFZCRkVf?=
	=?koi8-r?b?R0VUX0lORk8gZmFpbGVkOiBPcGVyYXRpb24gbm90IHN1cHBvcnRl?=
	=?koi8-r?b?ZA==?=
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


> On Thu, Apr 24, 2008 at 8:29 PM, Igor Nikanov <goga777@bk.ru> wrote:
> > Hi
> >
> >  I have installed the latest multiproto with hvr4000 patch from Gregoire Favre
> >  http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024487.html
> >
> >  after that I have installed the szap2 from dvb-apps
> >  But with szap2 I have the error ioctl DVBFE_GET_INFO failed: Operation not supported
> >  Can somebody comment ?
> >
> >  # ./szap2 -c 19 -n1
> >
> >  reading channels from file '19'
> >  zapping to 1 'Pro7':
> >  sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid = 0x0103 sid = 0x27d8
> >  Querying info .. Delivery system=DVB-S
> >  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> >  ioctl DVBFE_GET_INFO failed: Operation not supported
> >
> >
> >  Igor
> >
> 
> Hi
> 
> Try this patch.
> 
> wget -O szap-multiproto-apiv33.diff
> http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080406/a365d65c/attachment.bin

this patched szap2 didn't help to me, too :(

goga:/usr/src/szap2# ./szap2 -c 19 -n 1
reading channels from file '19'
zapping to 1 'Pro7':
sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid = 0x0103 sid = 0x27d8 (fec = -2147483648, mod = 2)
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl DVBFE_GET_INFO failed: Invalid argument

Igor



 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

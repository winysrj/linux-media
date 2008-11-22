Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tut.by ([195.137.160.40] helo=speedy.tutby.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@tut.by>) id 1L3wTc-0000By-KD
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 18:41:01 +0100
Received: from [213.184.224.41] (account liplianin@tut.by HELO
	dynamic-vpdn-128-2-82.telecom.by)
	by speedy.tutby.com (CommuniGate Pro SMTP 5.1.12)
	with ESMTPA id 98410311 for linux-dvb@linuxtv.org;
	Sat, 22 Nov 2008 19:40:52 +0200
Content-Disposition: inline
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Nov 2008 19:40:39 +0200
MIME-Version: 1.0
Message-Id: <200811221940.39429.liplianin@tut.by>
Subject: Re: [linux-dvb] STV0900, STV0903 (BAB) frontend drivers
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

> Hi all,
>
> I am pleased to let you know that an initial version of the STV090x
> driver to support the STV0900 Dual DVB-S2 and the STV0903 Single DVB-S2
> Broadcast devices (BAB) (currently only the Broadcast chips are
> supported, the Professional chips (AAB) will be supported only in the
> Broadcast Mode alone for now).
>
> After quite some work, the STV090x driver is available in the SAA716x
> repository at
>
> http://jusst.de/hg/saa716x
>
> Currently the driver is heavily in flux. The initial driver is based on
> the multiproto API, a V5 version will be available soon.
>
> Have fun.
Good news.

The code not allow to use CLKI. Also if SELX1RATIO = 0, we have error (See stv090x_get_mclk 
procedure).

Thanks
>
> Regards,
> Manu
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

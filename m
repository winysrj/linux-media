Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx4.orcon.net.nz ([219.88.242.54] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lennon@orcon.net.nz>) id 1JSq1x-0001td-So
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 09:46:50 +0100
Received: from Debian-exim by mx4.orcon.net.nz with local (Exim 4.68)
	(envelope-from <lennon@orcon.net.nz>) id 1JSq1m-0006Uf-Er
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 21:46:38 +1300
Message-ID: <BF191244F364492AA427C03CCC6D0DD9@CraigPC>
From: "Craig Whitmore" <lennon@orcon.net.nz>
To: "Igor" <goga777@bk.ru>,
	"ga ver" <gavermer@gmail.com>
References: <468e5d620802220813q4b39c4ecpb9297db74884547d@mail.gmail.com>
	<E1JSpgF-0003HY-00.goga777-bk-ru@f124.mail.ru>
In-Reply-To: <E1JSpgF-0003HY-00.goga777-bk-ru@f124.mail.ru>
Date: Sat, 23 Feb 2008 21:46:35 +1300
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR 4000 firmware not loaded?
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


>
> btw 20 February Darron Broad was updated the hvr4000 patches for current 
> HG
>

Yes I am using them at the moment. Works. Not much difference (as far as I 
can tell) than the version before that except it patches cleanly on the 
latest hg and it now says correctly:

DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
DVB: registering adapter 0 frontend 1 (Conexant CX22702 DVB-T)...

Thanks
Craig


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

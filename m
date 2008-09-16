Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gate1.ipvision.dk ([217.195.186.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <benny+usenet@amorsen.dk>) id 1Kfg2G-0002TW-0G
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 21:16:30 +0200
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <48CD1F3E.6080900@linuxtv.org>
	<564277.58085.qm@web46102.mail.sp1.yahoo.com>
	<m31vzkujjk.fsf@ursa.amorsen.dk>
	<alpine.NEB.2.00.0809161818250.4540@Arg.OFQ.QlaQAF.qx>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Tue, 16 Sep 2008 21:16:18 +0200
In-Reply-To: <alpine.NEB.2.00.0809161818250.4540@Arg.OFQ.QlaQAF.qx> (BOUWSMA
	Barry's message of "Tue\, 16 Sep 2008 19\:04\:56 +0000 \(UTC\)")
Message-ID: <m3wshbucjh.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] OT: Dual/BSD Licensing
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

BOUWSMA Barry <freebeer.bouwsma@gmail.com> writes:

> There are, however, numerous dual GPL/BSD license files to
> be found, some with different wordings.

Dual licensed files don't count, you can just ignore the license you
don't like. I'm saying that only-GPL'd .c-files are a non-starter for
*BSD kernels.

However, when things are added to the official Linux kernel,
dual-BSD-GPL files often have their BSD license removed, and
compatibility ifdef's are almost always removed. That can be a
challenge if you try to keep a unified code base.


/Benny


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

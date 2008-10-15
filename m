Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KpuKl-0001rc-KA
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 02:33:53 +0200
Message-ID: <48F53A68.4070506@linuxtv.org>
Date: Tue, 14 Oct 2008 20:33:44 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: korey_avail@yahoo.com
References: <359313.45387.qm@web57511.mail.re1.yahoo.com>
In-Reply-To: <359313.45387.qm@web57511.mail.re1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
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

Korey ODell wrote:
> Does reading this card's signal strength work for anyone? I've tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports a lock and otherwise works fine but basically reports 0 for a strength reading.


There are two versions of this card -- one that uses a s5h1409, and the other uses a s5h1411.  Which version do you have?

(dmesg output will indicate which board you have)

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

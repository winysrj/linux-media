Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tut.by ([195.137.160.40] helo=speedy.tutby.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@tut.by>) id 1KjGn2-0001av-6x
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 19:07:37 +0200
Received: from [91.149.190.211] (account liplianin@tut.by HELO
	useri.liplianin.net)
	by speedy.tutby.com (CommuniGate Pro SMTP 5.1.12)
	with ESMTPA id 62650418 for linux-dvb@linuxtv.org;
	Fri, 26 Sep 2008 20:07:25 +0300
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Fri, 26 Sep 2008 20:07:09 +0300
References: <48DBAA96.6070500@interia.pl> <48DC921D.6010801@interia.pl>
In-Reply-To: <48DC921D.6010801@interia.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809262007.09162.liplianin@tut.by>
Subject: [linux-dvb]  Common carrier_width
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

Would it be a common thing to implement calculation of carrier width?

static u32 carrier_width(u32 symbol_rate, fe_rolloff_t rolloff)
{
	u32 rlf;

	switch(rolloff) {
	case ROLLOFF_20:
		rlf = 20;
		break;
	case ROLLOFF_25:
		rlf = 25;
		break;
	default:
		rlf = 35;
		break;
	}

	return (symbol_rate  + (symbol_rate * rlf) / 100);
}


Igor

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

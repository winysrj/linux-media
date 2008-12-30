Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1LHmbc-0002dU-6Y
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 22:58:29 +0100
Message-ID: <495A996F.4030200@iki.fi>
Date: Tue, 30 Dec 2008 23:58:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chi Min Wang <cmwang@ms1.hinet.net>, luca@ventoso.org
References: <48F84D5C.6020005@ms1.hinet.net>
In-Reply-To: <48F84D5C.6020005@ms1.hinet.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] GL861+AF9003+MT2060....
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

Hi.
And sorry very late reply.

Chi Min Wang wrote:
> I have an unknown USB DVB-T stick built by these 3 chips,but I could not
> find detailed spec for AF9003(it might be the channel decoder,maybe
> similar to AF9005 without USB-MPEG TS portion),so I could not modify the
> original AF9005/GL861 driver code for it. Did any one had tried such
> combination??

AF9003 is demodulator, it is 1st gen. The second generation solution is 
AF9013. This is similar as AF9005/AF9003 and AF9015/AF9013.
I think current AF9005 should be slipped to demodulator and USB-bridge 
modules, like AF9015 and AF9013. You can look example from AF9015/AF9013 
-modules. I think there is no very much interest to do that by Luca or 
any other because AF9003 is very rare. Actually this is very first time 
I hear someone have it.

regards
Antti

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

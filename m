Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JyHAD-0000Vp-EW
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 04:01:18 +0200
Message-ID: <483230CA.7030204@iki.fi>
Date: Tue, 20 May 2008 05:00:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Owen Townend <owen.townend@gmail.com>
References: <bb72339d0805191836l26aa826fl3b6dd3aafa20712@mail.gmail.com>
In-Reply-To: <bb72339d0805191836l26aa826fl3b6dd3aafa20712@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kworld 399U Dual DVB-T USB tuner
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

Owen Townend wrote:
> So two questions:
>   What can I do to enable the second tuner on the dongle?
>   How can I compile the cx88 drivers along with the rest in the af9015 checkout?

> [4] http://linuxtv.org/hg/~anttip/af9015/rev/22fc34924b9e

You should use newer tree:
http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
I have feeling that both tuners should work (if I have not broken 
something)...

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

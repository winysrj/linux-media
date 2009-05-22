Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-px0-f106.google.com ([209.85.216.106])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1M7cNW-0003N1-J6
	for linux-dvb@linuxtv.org; Fri, 22 May 2009 23:34:11 +0200
Received: by pxi4 with SMTP id 4so1785703pxi.3
	for <linux-dvb@linuxtv.org>; Fri, 22 May 2009 14:33:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 May 2009 14:33:32 -0700
Message-ID: <cae4ceb0905221433k3bb349c9oac96787e5472fd0a@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] how to calculate the Snr value for DVICO DVB-T Dual
	express card
Reply-To: linux-media@vger.kernel.org
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

Hello:
this is the output of the status... I would like to know how to
calculate the the SNR DB value. Thank you

status 1e | signal b788 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1e | signal b78c | snr 0f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1e | signal b77c | snr 0f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1e | signal b780 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1e | signal b774 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1e | signal b77c | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

Audrey

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1M91Wx-0007IG-LN
	for linux-dvb@linuxtv.org; Tue, 26 May 2009 20:37:44 +0200
Received: by wf-out-1314.google.com with SMTP id 28so1278157wff.17
	for <linux-dvb@linuxtv.org>; Tue, 26 May 2009 11:37:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 May 2009 11:37:36 -0700
Message-ID: <cae4ceb0905261137g7f1e7aa5w1f0361bbe704e147@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] how to get the SNR DB value for DVICO DVB-T Dual
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
calculate the the SNR DB value. Thank you so much!
The frontend they used for DVB-T DUAL express is "Zarlink zl10353 DVB-T"

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

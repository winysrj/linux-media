Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LABk5-0005nJ-Jq
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 00:11:50 +0100
Received: by rv-out-0506.google.com with SMTP id b25so153161rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 09 Dec 2008 15:11:44 -0800 (PST)
Message-ID: <cae4ceb0812091511s668dcc5fj793e7efc113fedfd@mail.gmail.com>
Date: Tue, 9 Dec 2008 15:11:43 -0800
From: "Tu-Tu Yu" <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Question about Dvico HDTV7 Dual Express tv tuner card
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

Hi Sirs:
I am working on the Dvico HDTV7 Dual Express TV tuner card under Linux
environment with kernel (2.6.26).
When I check the snr value and signal status about every 10 seconds,
it works fine in first few hours, but it will stop after about 12 - 24
hours.
I found out if i check the snr and signal status every second. It will
stop after 5 hours.
If I check the snr and siganl status every time it read PES, it will
stop in few minutes.
And it will show the message==> value too large for defined data type,
Read -1 byte from DVR.
Do you think it because the driver is not compatible with my Desktop?
Or I shouldnt check the snr value?
Thank you so much
Tu Tu Yu
tutuyu@usc.edu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ydgoo9@gmail.com>) id 1KwvAN-0003Qw-OK
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 09:52:08 +0100
Received: by ti-out-0910.google.com with SMTP id w7so1457789tib.13
	for <linux-dvb@linuxtv.org>; Mon, 03 Nov 2008 00:52:01 -0800 (PST)
Message-ID: <38dc7fce0811030052i1eb70355v8b18df3dd9d3ac5c@mail.gmail.com>
Date: Mon, 3 Nov 2008 17:52:00 +0900
From: YD <ydgoo9@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] buffer overflow error.
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

Hello, All

I got a error. "dmxdev: buffer overflow" sometimes. especially
recording the files from 2 frontend devices.
My modification is that I changed the buffer size 10*188*1024 --> 20*188*1024.
But I still gets this error.
It is caused from the system load or performance ? I do not understand
why this happen.

Please give me some comments or help.

Thanks,
youngduk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

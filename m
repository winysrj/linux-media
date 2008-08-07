Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ydgoo9@gmail.com>) id 1KR0UJ-00068c-6r
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 10:04:48 +0200
Received: by ti-out-0910.google.com with SMTP id w7so183841tib.13
	for <linux-dvb@linuxtv.org>; Thu, 07 Aug 2008 01:04:38 -0700 (PDT)
Message-ID: <38dc7fce0808070104j1af3bfa7q415f06f2737e3f57@mail.gmail.com>
Date: Thu, 7 Aug 2008 17:04:38 +0900
From: YD <ydgoo9@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] stv0903 driver has a problem locking the DVB-S2
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

Hello all,

I am making the stv0903(support DVB-S/S2) driver.
I have implemented the initialize routine and search algorithm with
help of ST's reference code.
In case of DVB-S, it works well but DVB-S2 has some problem on
checking the lock.

I would like to to get some help what is wrong.
Or any experience on this is welcome.

Regards,

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

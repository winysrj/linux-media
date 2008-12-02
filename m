Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7e9B-00063r-NW
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 23:55:14 +0100
Received: by ey-out-2122.google.com with SMTP id 25so2131092eya.17
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 14:55:10 -0800 (PST)
Message-ID: <412bdbff0812021455n221ee909nba6c7e546f1a0650@mail.gmail.com>
Date: Tue, 2 Dec 2008 17:55:09 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: [linux-dvb] Pinnacle 80e support: not going to happen...
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

For those of you waiting for Linux support for the Pinnacle 80e, I
have some bad news:  it's not going to happen.

After investing over 100 hours doing the driver work, adding support
for the Empia em2874, integrating with the Linux tda18271 driver,
incorporating the Micronas drx reference driver source, and doing all
the testing, Micronas has effectively killed the project.  They
decided that their intellectual property was too valuable to make
available their reference driver code in source code form.  Even
worse, because I've seen the sources I am effectively prevented from
writing any sort of reverse engineered driver for the drx-j.

Obviously, I would have preferred they told me this *before* I spent
all the time doing the work, but there's not a whole lot I can do
about that now....

I figured I should let those of you know who have been waiting for
this support (in particular those I told that support was completed
and just waiting on Micronas's legal department).

I wouldn't suggest buying any devices that make use of the drx-j,
drx-k, or drx-d devices under the expectation that support for those
chipsets will be available under Linux at some point.  In terms of
Pinnacle products, stick with the 801e (or the 800e or 801e-se).

It's worth noting that the people at Pinnacle have been great in their
supporting me in my efforts to add Linux support for their products.
They provided sample hardware, engineering level support, and
connected me with the right people at the chipset vendors.  The fact
that this device cannot be supported is in no way their fault.

Also, I would like to take a minute and express my thanks to Michael
Krufky in particular for taking the time to help me work through
numerous issues such as getting that first tuning lock on the
tda18271.

I wish I had better news, but that's the status.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

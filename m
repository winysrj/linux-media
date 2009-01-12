Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LMOSE-000495-Lo
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 16:11:51 +0100
Received: by qw-out-2122.google.com with SMTP id 9so5615145qwb.17
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 07:11:45 -0800 (PST)
Message-ID: <412bdbff0901120711h7672ef3eg3a32ab6c5f8a348d@mail.gmail.com>
Date: Mon, 12 Jan 2009 10:11:45 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Any users of EVGA inDtube USB Tuner Stick out there?
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

I was doing some work on driver support for a user of the EVGA inDtube
USB Tuner Stick, and I got the ATSC support working.  Unfortunately,
the user managed to physically damage the board, so the analog support
is non-functional.

Are there any other users out there of this device who might be
willing to help in testing the patch before it goes into the mainline
kernel?

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

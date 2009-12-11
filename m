Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <amlopezalonso@gmail.com>) id 1NJ6sc-0007aC-5c
	for linux-dvb@linuxtv.org; Fri, 11 Dec 2009 15:54:02 +0100
Received: by ewy4 with SMTP id 4so1169347ewy.12
	for <linux-dvb@linuxtv.org>; Fri, 11 Dec 2009 06:53:29 -0800 (PST)
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?= <amlopezalonso@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 11 Dec 2009 14:53:22 +0000
MIME-Version: 1.0
Message-Id: <200912111453.22845.amlopezalonso@gmail.com>
Subject: [linux-dvb] dib0700: Nova-T-500 remote - mixed button codes
Reply-To: linux-media@vger.kernel.org, amlopezalonso@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi all,

I own a Hauppauge Nova-T-500 in a box running Mythbuntu 9.10. The card runs 
fine except when it comes to the in-built remote sensor: 

Whenever I press any button, the remote sensor seems to receive some other 
keycodes aside the proper one (i.e. when I press Volume Up button the sensor 
receives it most of the time, but sometimes it understands some other buttons 
are pressed like ArrowDown, Red button and so, making MythTV experience very 
annoying). There are only three buttons that are always well received with no 
confusion at all: "OK", "ArrowDown" and "Play". This behavior occurs with two 
identical remotes I own (one of them belonging to a WinTV HVR-1100) and 
another card user has reported a similar behavior with its own and same 
remote.

I tested both remotes with the HVR-1100 and they behave perfectly, so I guess 
this is not a remote related issue.

Though I have tried several LIRC setup files and swapped dvb_usb_dib0700 
firmware files (1.10 and 1.20 versions) they make no working difference at 
all.

I also tried rebuilding v4l-dvb code to no avail.

Any suggestions? I would gladly provide further info/logs upon request.

Cheers,
Antonio

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

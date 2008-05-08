Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.schwan@gmail.com>) id 1Ju1aC-000811-BQ
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 10:34:37 +0200
Received: by fg-out-1718.google.com with SMTP id e21so460858fga.25
	for <linux-dvb@linuxtv.org>; Thu, 08 May 2008 01:34:28 -0700 (PDT)
Message-ID: <4822BB11.6050100@leuchtturm-it.de>
Date: Thu, 08 May 2008 10:34:25 +0200
From: Dennis Schwan <dennis.schwan@leuchtturm-it.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] cx88 general errors: 0x00000100
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

Hi,

in my dmesg i find hundreds of these messages:

[55503.826432] cx88[0]/2-mpeg: general errors: 0x00000100
[55504.835809] cx88[0]/2-mpeg: general errors: 0x00000100
[55505.843346] cx88[0]/2-mpeg: general errors: 0x00000100
[55505.844585] cx88[0]/2-mpeg: general errors: 0x00000100
[55505.850033] cx88[0]/2-mpeg: general errors: 0x00000100
[55506.851012] cx88[0]/2-mpeg: general errors: 0x00000100

The card does not make any problems but it fills my syslog with these 
messages, what do they mean?

Regards,
Dennis

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

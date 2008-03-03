Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dmlb2000@gmail.com>) id 1JWGeJ-00025D-Hq
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 20:48:38 +0100
Received: by wr-out-0506.google.com with SMTP id c55so364394wra.11
	for <linux-dvb@linuxtv.org>; Mon, 03 Mar 2008 11:48:31 -0800 (PST)
Message-ID: <9c21eeae0803031148j11233fddxf2c6862d473f7fb3@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:48:24 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <47CC2114.5010402@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <9c21eeae0802282219r4280de1ex6d47a5be2759fb52@mail.gmail.com>
	<47C82112.3080404@linuxtv.org>
	<9c21eeae0803021705g13913d49m796e3398682fdee1@mail.gmail.com>
	<47CC2114.5010402@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx23885 status?
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

>  Thanks David, did it actually fix your issue or just remove the debug spew?

The patch adds a format that is apparently being used by my hardware.
I reverse engineered what the format was from the hex value that was
given to format_by_fourcc which was spewing into the dmesg log.  It
doesn't show any video just a green screen so I guess the answer is
both if that's the current state of the driver.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

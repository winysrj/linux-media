Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KVYxI-0007NV-3l
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 23:41:33 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5V0095KAW31GR0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 19 Aug 2008 17:40:57 -0400 (EDT)
Date: Tue, 19 Aug 2008 17:40:51 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <6664ae760808191423u1147789eve2cae5ea6dbdad80@mail.gmail.com>
To: Jay Modi <jaymode@gmail.com>
Message-id: <48AB3DE3.7030406@linuxtv.org>
MIME-version: 1.0
References: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
	<48AAF9FB.6010108@ecst.csuchico.edu>
	<6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
	<48AB3507.8030302@linuxtv.org>
	<6664ae760808191423u1147789eve2cae5ea6dbdad80@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

Jay Modi wrote:
> On Tue, Aug 19, 2008 at 5:03 PM, Steven Toth <stoth@linuxtv.org 
> <mailto:stoth@linuxtv.org>> wrote:
> 
>     # make unload
>     # modprobe cx25840 debug=1
>     # modprobe cx23885 debug=1
> 
>     Then cat /dev/video1 >test.mpg
> 
> 
> I did that and I received an I/O error:
> cat /dev/video2 > test.mpg
> cat: /dev/video2: Input/output error
> 
> The output from dmesg was too large for me to fill comfortable pasting 
> in an email so I attached it (hope that is ok).

Remove all other video drivers (with make unload) and try again.

If the HVR1800 is the only capture in the system then it will be 
registered as /dev/video0 and /dev/video1.

If you have to, try physically removing the other card and re-run the test.

Regards,

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

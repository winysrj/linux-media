Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <foceni@gmail.com>) id 1LsOPq-00014u-By
	for linux-dvb@linuxtv.org; Fri, 10 Apr 2009 23:37:39 +0200
Received: by yw-out-2324.google.com with SMTP id 2so883935ywt.41
	for <linux-dvb@linuxtv.org>; Fri, 10 Apr 2009 14:37:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DF9CB7.5080802@ewetel.net>
References: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>
	<49DF9CB7.5080802@ewetel.net>
Date: Fri, 10 Apr 2009 23:37:33 +0200
Message-ID: <621110570904101437g5843eb21h8a0c894cc9bb48d@mail.gmail.com>
From: Dave Lister <foceni@gmail.com>
To: Hartmut <spieluhr@ewetel.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
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

2009/4/10 Hartmut <spieluhr@ewetel.net>:
> I have the same card since 6 weeks and it works in "non HD-TV-mode" on
> opensuse 11.0. The driver is: Driver used:
> http://mercurial.intuxication.org/hg/s2-liplianin. From what you wrote I
> think the card is working. But try to scan in this way:
>
> scan-s2 -a 1 -s 0 -x 0 -t 1 /usr/share/dvb/dvb-s/Astra-19.2E >
> ~/.szap/channels1.conf
>
> This worked for me. -a 1 is the my second TV-card, you should use 0, -s 0 is
> OK, -x 0 finds only free-to-air-channels, t -1 finds only TV. You output in
> dmesg is OK, shows that the card is working.
>

It's really working? That would be great, because s2-liplianin is
S2API-based; DVB API v5 is AFAIK the future. I've only had _some_
success with the multiproto mantis driver just today, but that one is
deprecated and I'm not very happy about it. Now I can see basic DVB-S
picture, but the rest is almost unusable. I'd like to ask you for a
few details about your setup. I'd be very grateful for this info, as
it might allow me to switch to the new driver:

1) cat /proc/version
2) lspci -v -v
3) lsmod
4) dmesg (or a logfile containing your SkyStar HD2 driver msg)
5) scan-s2 (console output & dmesg logs about bandwidth/frequency get/set)
6) which revision of s2-liplianin you use? (could you .tar.gz and
upload for me?)

>From what I've seen of others' logs, mine is actually different: every
time the driver changes tuning frequency, it then calls "get" to
verify the change;  this works for everybody, but in my logs you can
see that frequency is _always_ = 0. Whatever the driver sets, the 0
doesn't change. The same goes for "bandwidth", it never changes from
the default value of 10000000. Example:

NOT OK (my S2API mantis):
stb6100_set_bandwidth: Bandwidth=51610000 <- request
stb6100_get_bandwidth: Bandwidth=10000000 <- no change
stb6100_get_bandwidth: Bandwidth=10000000
stb6100_set_frequency: Frequency=1951500 <- request
stb6100_get_frequency: Frequency=0 <- no change!

OK (my multiproto mantis):
stb6100_set_bandwidth: Bandwidth=48475000 <- request
stb6100_get_bandwidth: Bandwidth=48000000 <- changed
stb6100_set_frequency: Frequency=1925000 <- request
stb6100_get_frequency: Frequency=1925015 <- changed

Otherwise, I think you're right, I'm also confident that the driver
talks with the HW, but the crucial communication - tuning, locking,
etc. - doesn't get through. I have no idea why. Perhaps with your info
I'll be able to find the difference and port the necessary code from
multiproto to S2API. I think that's my only chance.


Best regards,
-- 
David Lister

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KVNOC-0005xc-Eo
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 11:20:33 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2572263rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 02:20:28 -0700 (PDT)
Message-ID: <7641eb8f0808190220r53c8e214r54e3d568dbfb454c@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:20:27 +0200
From: Beth <beth.null@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Last night I had the thing running and here are the results:


time dd if=/dev/dvb/adapter0/dvr0 of=test_100M.ts bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 35327.8 s, 3.0 kB/s

real	588m47.813s
user	0m0.000s
sys	0m1.020s


Hey ten hours for a 100Mb file, definitively it's a turtle.

What can I do with that file? as mplayer and similar doesn't plays it.

Can I turn on something for debugging?

Thats all (for today) thanks and kind regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

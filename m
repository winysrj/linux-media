Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1LLUQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 15:16:42 -0500
Received: by wgbdr13 with SMTP id dr13so12037566wgb.1
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 12:16:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE1F507.2000705@redhat.com>
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com>
 <4EE08D88.2070806@redhat.com> <4EE0C312.90401@gmail.com> <4EE0D264.4090306@redhat.com>
 <4EE114E6.9040307@redhat.com> <CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com>
 <CAKdnbx6-448+3=8ONrcd0pGhbJ1P4vKZPse-RYHGnhkpHfzW8w@mail.gmail.com>
 <4EE1E714.5060908@redhat.com> <4EE1F507.2000705@redhat.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Mon, 12 Dec 2011 21:16:20 +0100
Message-ID: <CAKdnbx6dP_wXFDDQ_JZPb5uctrqUZDBw9poUfr_-kMTCBxOP1A@mail.gmail.com>
Subject: Re: HVR-930C DVB-T mode report
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,

with latest git, w_scan partially working only if adding  -t2  or t3.

It seems that scan quality of w_scan is lower if compared to dvb_app scan

# w_scan -f t -t2 -x >it-Venice-w

# w_scan -f t -t2 -I it-Venice-w >stdout
wc -l stdout
73

# w_scan -f t -t3  >stdout
130 it-Venice-w.stdout

# scan -f1 it-Venice-w -vvvv > it-Venice.stdout
[..]
dumping lists (62 services)
Done.


modprobe dvb-core dvb_mfe_wait_time=1

# scan -f1 it-Venice-w -vvvv > it-Venice.stdout
[..]
dumping lists (77 services)
Done.

# w_scan -F -f t -t2 -x -vvvvvvv -a /dev/dvb/adapter0/frontend1 > it-Venice-w_v1
 [...]
dumping lists (115 services)
Done.

Using other device (hauppauge hvr-900h)
# w_scan -f t -x -vvvvvvvvvvvv > it-venice_hvr900h
[...]
dumping lists (461 services)
Done.

I can't figure out why these big differences...


regards,
Eddi

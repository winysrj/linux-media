Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41010 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1LLUoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 15:44:39 -0500
Received: by qcqz2 with SMTP id z2so3927843qcq.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 12:44:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx6dP_wXFDDQ_JZPb5uctrqUZDBw9poUfr_-kMTCBxOP1A@mail.gmail.com>
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com>
	<4EE08D88.2070806@redhat.com>
	<4EE0C312.90401@gmail.com>
	<4EE0D264.4090306@redhat.com>
	<4EE114E6.9040307@redhat.com>
	<CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com>
	<CAKdnbx6-448+3=8ONrcd0pGhbJ1P4vKZPse-RYHGnhkpHfzW8w@mail.gmail.com>
	<4EE1E714.5060908@redhat.com>
	<4EE1F507.2000705@redhat.com>
	<CAKdnbx6dP_wXFDDQ_JZPb5uctrqUZDBw9poUfr_-kMTCBxOP1A@mail.gmail.com>
Date: Mon, 12 Dec 2011 15:44:37 -0500
Message-ID: <CAGoCfixSXbwb3S-qDw8XpKnRr2rjQHyJP52de947HnGweF5=dw@mail.gmail.com>
Subject: Re: HVR-930C DVB-T mode report
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eddi De Pieri <eddi@depieri.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2011 at 3:16 PM, Eddi De Pieri <eddi@depieri.net> wrote:
> Hi to all,
>
> with latest git, w_scan partially working only if adding  -t2  or t3.
>
> It seems that scan quality of w_scan is lower if compared to dvb_app scan

Hi Eddi,

A really useful test would be to run the exact same scan twice in a
row and see if you get consistent results (in terms of the number of
frequencies are found and which ones).  It would be worthwhile to know
if there's a consistent problem locking to certain frequencies, or
whether you get a lock for any given frequency is random.  Run the
scan with the exact same parameters again and see if you get the same
results.

Such information will drive whether the developers need to investigate
why certain frequencies always fail to lock, or whether there is a
more general problem with tuning that results in lock failure
regardless of frequency.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

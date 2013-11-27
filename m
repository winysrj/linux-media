Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3K0Wb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 17:31:27 -0500
Date: Wed, 27 Nov 2013 20:31:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libdvbv5: dvb_table_pat_init is leaking memory
Message-ID: <20131127203121.78baf121@infradead.org>
In-Reply-To: <CAJxGH09uZhZ0m4GcpAF4moURp18hPmBh5cOP_ZHoNxAaadL_XQ@mail.gmail.com>
References: <CAJxGH09uZhZ0m4GcpAF4moURp18hPmBh5cOP_ZHoNxAaadL_XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Wed, 27 Nov 2013 22:55:32 +0100
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> Coverity noticed that dvb_table_pat_init leaks the reallocated memory
> stored in pat:
> http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/libdvbv5/descriptors/pat.c#l26
> 
> Mauro, could you please check?

On my tests with Valgrind, I'm not noticing any memory leak there, at
least on the very latest version I pushed today[1].

I tested here with DVB-T, DVB-T2, DVB-S, DVB-S2 and DVB-C.

I didn't test the current version yet with ATSC or ISDB-T. Those are
on my todo list. I'll likely do ATSC test today or tomorrow.

ISDB-T test might take some time, as I'm having some troubles to test it
here those days.

That's said, I would love to get rid of that realloc() on PAT, but this
would break the existing userspace interface. So, such change, if done,
would require some care, as at least tvdaemon relies on it.

Regards,
Mauro

[1] Not sure if you noticed, but I added ~80 patches for it today.

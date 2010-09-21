Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:61430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab0IUUBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 16:01:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: Re: Remaining BKL users, what to do
Date: Tue, 21 Sep 2010 22:01:37 +0200
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jan Kara <jack@suse.cz>,
	codalist@coda.cs.cmu.edu, autofs@linux.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Anders Larsen <al@alarsen.net>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
References: <ead83d0d-e0ae-456d-8702-16ed8d3a179a@email.android.com>
In-Reply-To: <ead83d0d-e0ae-456d-8702-16ed8d3a179a@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009212201.37372.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 18 September 2010 01:21:41 Petr Vandrovec wrote:
> 
> I'll try to come up with something for ncpfs.

Ok, good.

> Trivial lock replacement will open deadlock possibility when
> someone reads to page which is also mmaped from the same 
> filesystem (like grep likes to do). BKL with its automated
> release on sleep helped (or papered over) a lot here.

Right, I was more or less expecting something like this.
So I guess this is some AB-BA deadlock with another mutex
or a call to flush_scheduled_work that is currently done
under the BKL?

There is still the possibility of just working around those
by adding explicit mutex_unlock() calls around those, which
is what I initially did in the tty subsystem. The better
long-term approach would obviously be to understand all of
the data structures that actually need locking and only
lock the actual accesses, but that may be more work than
you are willing to spend on it.

	Arnd

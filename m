Return-path: <mchehab@pedra>
Received: from de01.mail.all-tld.net ([195.140.232.8]:60574 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0IPQbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 12:31:08 -0400
Date: Thu, 16 Sep 2010 18:09:10 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: Remaining BKL users, what to do
To: Arnd Bergmann <arnd@arndb.de>
Cc: codalist@coda.cs.cmu.edu, autofs@linux.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de>
In-Reply-To: <201009161632.59210.arnd@arndb.de> (from arnd@arndb.de on Thu
	Sep 16 16:32:59 2010)
Message-Id: <1284653350l.20726l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 2010-09-16 16:32:59, Arnd Bergmann wrote:
> The big kernel lock is gone from almost all code in linux-next, this is
> the status of what I think will happen to the remaining users:

> fs/qnx4:
> 	Should be easy to fix, there are only a few places in the code that
> 	use the BKL. Anders?

Will do.

Cheers
Anders


Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:53212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0JRQUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 12:20:09 -0400
Date: Mon, 18 Oct 2010 12:19:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: codalist@coda.cs.cmu.edu,
	ksummit-2010-discuss@lists.linux-foundation.org,
	autofs@linux.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Anders Larsen <al@alarsen.net>, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>,
	David Miller <davem@davemloft.net>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: [v2] Remaining BKL users, what to do
Message-ID: <20101018161924.GA9571@infradead.org>
References: <201009161632.59210.arnd@arndb.de>
 <201010181742.06678.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010181742.06678.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Before we get into all these fringe drivers:

 - I've not seen any progrss on ->get_sb BKL removal for a while
 - locks.c is probably a higher priorit, too.


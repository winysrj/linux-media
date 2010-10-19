Return-path: <mchehab@pedra>
Received: from smtp-out002.kontent.com ([81.88.40.216]:49620 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0JSTuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 15:50:04 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Date: Tue, 19 Oct 2010 21:40:47 +0200
Cc: Valdis.Kletnieks@vt.edu, Dave Airlie <airlied@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	codalist@telemann.coda.cs.cmu.edu,
	ksummit-2010-discuss@lists.linux-foundation.org,
	autofs@linux.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
	Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Bryan Schumaker <bjschuma@netapp.com>,
	Christoph Hellwig <hch@infradead.org>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	linux-fsdevel@vger.kernel.org,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Hendry <andrew.hendry@gmail.com>,
	linux-media@vger.kernel.org
References: <201009161632.59210.arnd@arndb.de> <21406.1287512693@localhost> <20101019193735.GA4043@kroah.com>
In-Reply-To: <20101019193735.GA4043@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192140.47433.oliver@neukum.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Dienstag, 19. Oktober 2010, 21:37:35 schrieb Greg KH:
> > So no need to clean it up for multiprocessor support.
> > 
> > http://download.intel.com/design/chipsets/datashts/29067602.pdf
> > http://www.intel.com/design/chipsets/specupdt/29069403.pdf
> 
> Great, we can just drop all calls to lock_kernel() and the like in the
> driver and be done with it, right?

No,

you still need to switch off preemption.

	Regards
		Oliver

Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:56531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab0IQNu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 09:50:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Remaining BKL users, what to do
Date: Fri, 17 Sep 2010 15:50:49 +0200
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jan Kara <jack@suse.cz>,
	codalist@coda.cs.cmu.edu, autofs@linux.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Anders Larsen <al@alarsen.net>,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Andrew Hendry <andrew.hendry@gmail.com>
References: <201009161632.59210.arnd@arndb.de> <201009171245.41930.arnd@arndb.de> <20100917133231.GA9411@infradead.org>
In-Reply-To: <20100917133231.GA9411@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171550.49282.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 17 September 2010, Christoph Hellwig wrote:
> 
> On Fri, Sep 17, 2010 at 12:45:41PM +0200, Arnd Bergmann wrote:
> > ncpfs: replace BKL with lock_super
> 
> Err, no.  lock_super is just as much on it's way out as the BKL.  We've
> managed to move it down from the VFS into a few remaining filesystems
> and now need to get rid of those users.  Please don't add any new ones.

Ok. I guess that's also a NAK for my the isofs patch I posted yesterday
then. Do you have any suggestions for an alternative approach?

	Arnd

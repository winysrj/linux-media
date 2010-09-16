Return-path: <mchehab@pedra>
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:58594 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab0IPVx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 17:53:26 -0400
Subject: Re: Remaining BKL users, what to do
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20100916150459.GA8437@quack.suse.cz>
Date: Thu, 16 Sep 2010 22:26:24 +0100
Cc: Arnd Bergmann <arnd@arndb.de>, codalist@coda.cs.cmu.edu,
	autofs@linux.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Christoph Hellwig <hch@infradead.org>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <16843727-8A3D-48FF-9021-E0AD99C23E18@cam.ac.uk>
References: <201009161632.59210.arnd@arndb.de> <20100916150459.GA8437@quack.suse.cz>
To: Jan Kara <jack@suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 16 Sep 2010, at 16:04, Jan Kara wrote:
> On Thu 16-09-10 16:32:59, Arnd Bergmann wrote:
>> The big kernel lock is gone from almost all code in linux-next, this is
>> the status of what I think will happen to the remaining users:
> ...
>> fs/ncpfs:
>> 	Should be fixable if Petr still cares about it. Otherwise suggest
>> 	moving to drivers/staging if there are no users left.
>  I think some people still use this...

Yes, indeed.  Netware is still alive (unfortunately!) and ncpfs is used in a lot of Universities here in the UK at least (we use it about a thousand workstations and servers here at Cambridge University!).

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


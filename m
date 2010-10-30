Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:45172 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753936Ab0J3Xkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 19:40:40 -0400
Date: Sun, 31 Oct 2010 01:40:45 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Laurent Birtz <laurent.birtz@usherbrooke.ca>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] bttv driver memory corruption
Message-ID: <20101030234045.GA15147@minime.bse>
References: <4CC5A390.9010800@usherbrooke.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC5A390.9010800@usherbrooke.ca>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Oct 25, 2010 at 11:34:40AM -0400, Laurent Birtz wrote:
> I've observed that the poison was corrupted at some random pages, but
> always in the first four bytes. The value of those bytes is 0x23232323.
> This byte sequence often appears in kernel oops reports on my setup.

I couldn't verify your findings by mallocing an equivalent of the
physical memory, filling everything with 0xdeadbeef, and then
periodically checking it didn't change while watching tv at 768x576
in YUY2.

Which video mode and resolution did you use in your tests?
Did you try loading bttv with triton1=1 and vsfx=1?

  Daniel

Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:36075 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaBEJkA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 04:40:00 -0500
Message-ID: <52F206D5.9060601@imgtec.com>
Date: Wed, 5 Feb 2014 09:39:33 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>,
	"Mauro Carvalho Chehab" <m.chehab@samsung.com>
CC: Sean Young <sean@mess.org>, <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
References: <20140115173559.7e53239a@samsung.com> <1390246787-15616-1-git-send-email-a.seppala@gmail.com> <20140121122826.GA25490@pequod.mess.org> <CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com> <20140122162953.GA1665@pequod.mess.org> <CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com> <20140122210024.GA3223@pequod.mess.org> <20140122200142.002a39c2@samsung.com> <CAKv9HNY7==4H2ZDrmaX+1BcarRAJd7zUE491oQ2ZJZXezpwOAw@mail.gmail.com> <20140204155441.438c7a3c@samsung.com> <CAKv9HNbYJ5FsQas=03u8pXCyiF5VSUfsOR46McukeisqVHme+g@mail.gmail.com>
In-Reply-To: <CAKv9HNbYJ5FsQas=03u8pXCyiF5VSUfsOR46McukeisqVHme+g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 05/02/14 07:03, Antti Seppälä wrote:
> To wake up with nuvoton-cir we need to program several raw ir
> pulse/space lengths to the hardware and not a scancode. James's
> approach doesn't support this.

Do the raw pulse/space lengths your hardware requires correspond to a
single IR packet (mapping to a single scancode)?

If so then my API is simply at a higher level of abstraction. I think
this has the following advantages:
* userspace sees a consistent interface at the same level of abstraction
as it already has access to from input subsystem (i.e. scancodes). I.e.
it doesn't need to care which IR device is in use, whether it does
raw/hardware decode, or the details of the timings of the current protocol.
* it supports hardware decoders which filter on the demodulated data
rather than the raw pulse/space lengths.

Of course to support this we'd need some per-protocol code to convert a
scancode back to pulse/space lengths. I'd like to think that code could
be generic, maybe as helper functions which multiple drivers could use,
which could also handle corner cases of the API in a consistent way
(e.g. user providing filter mask covering multiple scancodes, which
presumably pulse/space).

I see I've just crossed emails with Mauro who has just suggested
something similar. I agree that his (2) is the more elegant option.

Cheers
James


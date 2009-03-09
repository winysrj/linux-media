Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43297 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZCIXqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 19:46:17 -0400
Subject: Re: V4L2 spec
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	wk <handygewinnspiel@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <200903092344.04805.hverkuil@xs4all.nl>
References: <200903061523.15766.hverkuil@xs4all.nl>
	 <49B59230.1090305@gmx.de>
	 <412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>
	 <200903092344.04805.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 19:46:34 -0400
Message-Id: <1236642394.3104.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-09 at 23:44 +0100, Hans Verkuil wrote:
> On Monday 09 March 2009 23:10:56 Devin Heitmueller wrote:
> > On Mon, Mar 9, 2009 at 6:03 PM, wk <handygewinnspiel@gmx.de> wrote:

> > The reality is that there is *some* value a developer can contribute
> > in reviewing the content and providing feedback and a *TON* of grunt
> > work involved that can be done by anybody who takes the time to learn
> > docbook.  If someone wants to volunteer to do the former, I'm sure
> > some developers would be willing to do the latter.
> 
> Indeed. If someone could do the 'grunt' work of converting the dvb doc into 
> DocBook 

The Google leads me to ask:

What about a LaTeX to HTML or OOo Writer convertor:

http://www.tug.org/utilities/texconv/textopc.html#TeX4ht

(maybe oolatex?)

Then OOo Writer saving to DocBook?

I suspect it won't be perfect, but since existing software does the
heavy lifting, it beats manual conversion.


I didn't quite understand why a conversion is necessary, but I do see a
lot of hard-coded structures in the LaTeX documents, which I suspect is
a pain to keep up to date.



> and integrating it into the existing v4l docbook,

I'm not sure of the value in that.

<opinion>
Implmenting something to multiple (or multi-volume) specifications is
indeed a pain, but it makes documentation maintenance easier as the task
is easily divided along areas of personnel expertise.  Assuming the rate
of documentation maintencance does not rapidly increase, keeping
documentation maintenace simple is paramount.

Also multiple specifcations (or volumes) clearly group requirements into
large chunks of "I don't care about that volume" and "I do care about
this volume".  Combining the V4L2 and DVB spec into one volume would
probably be a strategic error for some tactical advantage in dealing
with hybrid devices.
</opinion>

Regards,
Andy


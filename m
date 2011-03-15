Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:50490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1COJAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 05:00:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH 2/7] davinci: eliminate use of IO_ADDRESS() on sysmod
Date: Tue, 15 Mar 2011 10:00:10 +0100
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sergei Shtylyov <sshtylyov@mvista.com>
References: <1300110947-16229-1-git-send-email-manjunath.hadli@ti.com> <201103141721.52033.arnd@arndb.de> <B85A65D85D7EB246BE421B3FB0FBB593024C246CB1@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C246CB1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151000.10350.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 15 March 2011 07:00:44 Nori, Sekhar wrote:

> > * If you need to access sysmod in multiple places, a nicer
> >   way would be to make the virtual address pointer static,
> >   and export the accessor functions for it, rather than
> >   having a global pointer.
> 
> Seems like opinion is divided on this. A while back
> I submitted a patch with such an accessor function and
> was asked to do the opposite of what you are asking here.
> 
> https://patchwork.kernel.org/patch/366501/
> 
> It can be changed to the way you are asking, but would
> like to know what is more universally acceptable (if
> at all there is such a thing).

One difference is that the base address pointer here
can be treated as read-only by using an accessor function,
which was not possible for the case you cited. Doing
an inline function would also let you make the access
more type-safe, e.g forcing the right kind of readl/writel
variant and possibly locking if necessary.

I would also argue against Sergei's point for the other
patch -- the current solution is not better than the originally
suggested one IMHO. I believe a better way would have
been to pass the maximum frequency as an argument to
da850_register_cpufreq() in that case.

However, neither of these discussion is really important,
and we don't have a strict rule for doing it one way
or the other. Just use common sense and decide case-by-case,
as I said in the previous comment, you got the important
parts right.

	Arnd

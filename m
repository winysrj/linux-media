Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:49278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZCGBuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 20:50:32 -0500
Date: Sat, 7 Mar 2009 02:50:06 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090307015006.GB3058@local>
References: <28050.62.70.2.252.1236161035.squirrel@webmail.xs4all.nl> <20090304210246.75a5b602@glory.loctelecom.ru> <200903041845.45469.hverkuil@xs4all.nl> <20090305210110.6c5f88e2@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090305210110.6c5f88e2@glory.loctelecom.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 05, 2009 at 09:01:10PM +0900, Dmitri Belimov wrote:
> Hi Hans 
> 
> I build fresh video4linux with your patch and my config for our cards.
> In a dmesg i see : found RDS decoder.
> cat /dev/radio0 give me some slow junk data. Is this RDS data??

Yes, because that's all you can read from /dev/radioX.

> Have you any tools for testing RDS?
> I try build rdsd from Hans J. Koch, but build crashed with:
> 
> rdshandler.cpp: In member function ‘void std::RDShandler::delete_client(std::RDSclient*)’:
> rdshandler.cpp:363: error: no matching function for call to ‘find(__gnu_cxx::__normal_iterator<std::RDSclient**, std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >, __gnu_cxx::__normal_iterator<std::RDSclient**, std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >, std::RDSclient*&)’
> 

Unfortunately, rdsd (and all the other RDS userspace software) is somehow
unmaintained ATM. I haven't got the time anymore, and there are not many
_active_ developers to take over the project. One serious problem is that
I wrote it in C++ (I wouldn't do it again).

Anyway, if you're really interested, I'll happily give you full write access
to the repository. The project is about to die without active developers.

If there's anyone out there who would like to take over maintainership of the
RDS userspace stuff, please let me know.


> P.S. Debian Lenny.
> 
> With my best regards, Dmitry.
> 
> > On Wednesday 04 March 2009 13:02:46 Dmitri Belimov wrote:
> > > > Dmitri,
> > > >
> > > > I have a patch pending to fix this for the saa7134 driver. The i2c
> > > > problems are resolved, so this shouldn't be a problem anymore.
> > >
> > > Good news!
> > >
> > > > The one thing that is holding this back is that I first want to
> > > > finalize the RFC regarding the RDS support. I posted an RFC a few
> > > > weeks ago, but I need to make a second version and for that I
> > > > need to do a bit of research into the US version of RDS. And I
> > > > haven't found the time to do that yet.
> > >
> > > Yes, I found your discussion in linux-media mailing list. If you
> > > need any information from chip vendor I'll try find. I can get it
> > > under NDA and help you.

I could help with docs, too.

> > >

Thanks,
Hans

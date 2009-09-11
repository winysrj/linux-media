Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33351 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZIKPyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 11:54:04 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 11 Sep 2009 21:23:50 +0530
Subject: RE: RFCv2: Media controller proposal
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA522B@dbde02.ent.ti.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <20090910172013.55825d2e@caramujo.chehab.org>
	 <200909102335.52770.hverkuil@xs4all.nl>
	 <20090911121342.08dd1939@caramujo.chehab.org>
 <829197380909110846t493deb9cga3a2af754f2e40cd@mail.gmail.com>
In-Reply-To: <829197380909110846t493deb9cga3a2af754f2e40cd@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Devin Heitmueller
> Sent: Friday, September 11, 2009 9:16 PM
> To: Mauro Carvalho Chehab
> Cc: Hans Verkuil; linux-media@vger.kernel.org
> Subject: Re: RFCv2: Media controller proposal
> 
> On Fri, Sep 11, 2009 at 11:13 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > Em Thu, 10 Sep 2009 23:35:52 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >
<snip>
> >
> > I was talking not about specific attributes, but about the V4L2
> API controls
> > that you may eventually need to "hijack" (using that context-
> sensitive
> > thread-unsafe approach you described).
> >
> > Anyway, by using sysfs, you won't have any thread issues, since
> you'll be able
> > to address each sub-device individually:
> >
> > echo 1 >/sys/class/media/mc0/video:dsp0/enable_stats
> >
> >
> >
> > Cheers,
> > Mauro
> 
> Mauro,
> 
> Please, *seriously* reconsider the notion of making sysfs a
> dependency
> of V4L.  While sysfs is great for a developer who wants to poke
> around
> at various properties from a command line during debugging, it is an
> absolute nightmare for any developer who wants to write an
> application
> in C that is expected to actually use the interface.  The amount of
> extra code for all the string parsing alone would be ridiculous
> (think
> of how many calls you're going to have to make to sscanf or atoi).
> It's so much more straightforward to be able to have ioctl() calls
> that can return an actual struct with nice things like enumeration
> data types etc.
> 
> Just my opinion, of course.
> 
[Hiremath, Vaibhav] Mauro,

Definitely SYSFS interface is a nightmare for the application developer, and again we have not thought of backward compatibility here.

How application would know/decide on which node is exist and stuff? Every video board will have his separate way of notions for creating SYSFS nodes and maintaining standard between them would be really mess. 

There has to be enumeration kind of interface to make standard application work seamlessly.

Thanks,
Vaibhav

> Devin
> 
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


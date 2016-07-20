Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47093
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbcGTKT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 06:19:59 -0400
Date: Wed, 20 Jul 2016 07:19:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160720071951.290e800b@recife.lan>
In-Reply-To: <E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
	<20160719164916.3ebb1c74@lwn.net>
	<20160719210023.2f8280ac@recife.lan>
	<E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jul 2016 08:07:54 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 20.07.2016 um 02:00 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Em Tue, 19 Jul 2016 16:49:16 -0600
> > Jonathan Corbet <corbet@lwn.net> escreveu:
> >   
> >> On Tue, 19 Jul 2016 11:53:19 -0300
> >> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> >>   
> >>> So, I guess we should set the minimal requirement to 1.2.x.    
> >> 
> >> *sigh*.
> >> 
> >> I hate to do that; things are happening quickly enough with Sphinx that
> >> it would be nice to be able to count on a newer version.  That said, one
> >> of my goals in this whole thing was to make it *easier* for developers to
> >> generate the docs; the DocBook toolchain has always been notoriously
> >> difficult in that regard.  Forcing people to install a newer sphinx by
> >> hand is not the way to get there.
> >> 
> >> So I guess we need to make sure things work with 1.2 for now.  I'd hope
> >> we could push that to at least 1.3 before too long, though, once the
> >> community distributions are there.  I think we can be a *bit* more
> >> aggressive with the docs than with the kernel as a whole.  
> > 
> > Yeah, that seems to be the right strategy, IMHO. With the patch I sent,
> > the media books will again build fine with 1.2.  
> 
> 
> It is a difficult situation, whatever we do, we will get in trouble. To
> handle this, (IMHO) at first we need a reference documentation.
> 
> > What we miss is the documentation for Sphinx 1.2 and 1.3 versions. The
> > site only has documentation for the very latest version, making harder
> > to ensure that we're using only the tags supported by a certain version.  
> 
> We could build the documentation of the (e.g.) 1.2 tag
> 
> https://github.com/sphinx-doc/sphinx/tree/1.2
> 
> by checkout the tag, cd to "./doc" and run "make html".
> I haven't tested yet, but it should work this way.
> 
> Jon, what do you think ... could we serve this 1.2 doc 
> on https://www.kernel.org/doc/ as reference?

Yeah, building the documentation for 1.2.3 worked. I added the
documentation at linuxtv.org:
	https://linuxtv.org/downloads/sphinx-1.2.3/

Yet, I agree that the best would be to host it at kernel.org,
and add a link for it at kernel-documentation.rst.

> And whats about those who have 1.3 (or any version >1.2) as default 
> in the linux distro? Should they install a virtualenv?  ... it is
> a dilemma.

Well, they won't notice if a newer tag is used. IMHO, the best would
be if we had some tag at the configuration file or at the book itself
that would specify the sphinx version, and produce an ERROR if a
tag for newer versions would be used.

Not having that means more work for maintainers, as we'll need to
check it when merging patches for documentation.

> 
> Sorry that I have not identified this earlier ... I'am using python
> a long time and for me it is common to set up build processes
> with a version decoupled from the OS version, mostly the up to date
> version .. thats why I have neglected any version problems :(
> 
> -- Markus --
> 
> 
> 
> > 
> > Thanks,
> > Mauro  
> 



Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:44425 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbcGTGIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 02:08:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160719210023.2f8280ac@recife.lan>
Date: Wed, 20 Jul 2016 08:07:54 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com> <578DF08F.8080701@xs4all.nl> <20160719081259.482a8c04@recife.lan> <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de> <20160719115319.316349a7@recife.lan> <20160719164916.3ebb1c74@lwn.net> <20160719210023.2f8280ac@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 02:00 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 19 Jul 2016 16:49:16 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
> 
>> On Tue, 19 Jul 2016 11:53:19 -0300
>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>> 
>>> So, I guess we should set the minimal requirement to 1.2.x.  
>> 
>> *sigh*.
>> 
>> I hate to do that; things are happening quickly enough with Sphinx that
>> it would be nice to be able to count on a newer version.  That said, one
>> of my goals in this whole thing was to make it *easier* for developers to
>> generate the docs; the DocBook toolchain has always been notoriously
>> difficult in that regard.  Forcing people to install a newer sphinx by
>> hand is not the way to get there.
>> 
>> So I guess we need to make sure things work with 1.2 for now.  I'd hope
>> we could push that to at least 1.3 before too long, though, once the
>> community distributions are there.  I think we can be a *bit* more
>> aggressive with the docs than with the kernel as a whole.
> 
> Yeah, that seems to be the right strategy, IMHO. With the patch I sent,
> the media books will again build fine with 1.2.


It is a difficult situation, whatever we do, we will get in trouble. To
handle this, (IMHO) at first we need a reference documentation.

> What we miss is the documentation for Sphinx 1.2 and 1.3 versions. The
> site only has documentation for the very latest version, making harder
> to ensure that we're using only the tags supported by a certain version.

We could build the documentation of the (e.g.) 1.2 tag

https://github.com/sphinx-doc/sphinx/tree/1.2

by checkout the tag, cd to "./doc" and run "make html".
I haven't tested yet, but it should work this way.

Jon, what do you think ... could we serve this 1.2 doc 
on https://www.kernel.org/doc/ as reference?

And whats about those who have 1.3 (or any version >1.2) as default 
in the linux distro? Should they install a virtualenv?  ... it is
a dilemma.

Sorry that I have not identified this earlier ... I'am using python
a long time and for me it is common to set up build processes
with a version decoupled from the OS version, mostly the up to date
version .. thats why I have neglected any version problems :(

-- Markus --



> 
> Thanks,
> Mauro


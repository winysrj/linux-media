Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0AUCHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 21:07:41 -0500
Message-ID: <4B57B6E4.2070500@infradead.org>
Date: Thu, 21 Jan 2010 00:07:32 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
CC: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl> <4B5592BF.8040201@infradead.org> <4B56C078.8000502@redhat.com> <12e7fb96118720cc47555e3a12a5fd53.squirrel@webmail.xs4all.nl> <4B57241E.2060107@infradead.org> <4B575068.8050105@redhat.com> <20100120210740.GJ4015@jenkins.home.ifup.org>
In-Reply-To: <20100120210740.GJ4015@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brandon Philips wrote:
> On 19:50 Wed 20 Jan 2010, Hans de Goede wrote:
>> On 01/20/2010 04:41 PM, Mauro Carvalho Chehab wrote:
>>> As we're discussing about having a separate tree for v4l2-apps,
>>> maybe the better is to port it to -git (in a way that we can
>>> preserve the log history).
> 
> I have a small script I used to convert the history of libv4l to
> git. Let me know when we are ready to drop them from the hg tree and I
> can do the conversion and post the result for review.
> 
> This is the result from the script for just libv4l:
>  http://ifup.org/git/?p=libv4l.git;a=summary

Seems fine, but we need to import the entire v4l2-apps.

> Also, I suggest we call the repo v4lutils? In the spirit of usbutils,
> pciutils, etc.

Hmm... as dvb package is called as dvb-utils, it seems more logical to call it
v4l2-utils, but v4l2utils would equally work.

IMO, the better is to use v4l2 instead of just v4l, to avoid causing any
mess with the old v4l applications provided with xawtv.
> 
>> Having a separate tree for v4l2-apps would work for me. If possible
>> with direct commit / push rights, given that I'm doing 90% of the
>> libv4l work.
> 
> I am fine with Hans doing this. Thanks Hans.

Ok.
> 
>>>> We would need to do
>>>> some rearranging in the directory structure of v4l2-apps, though.
>>> Yes. Maybe we can move the tools that aren't meant to be used on distros on a separate
>>> dir, like contrib, having a separate make install for building them.
>>>
>>> Also, we need to use some config tool like autoconf that will seek
>>> for dependencies and or require the needed ones or not compile the
>>> applications that depends on some library.
>>>
>> Ugh, I'm no fan of autoconf, but I can see this being handy, any volunteers for
>> doing this bit ?
> 
> I started getting libv4l converted to autoconf earlier. If you are OK
> with it I can provide patches after we get the repo converted.

Seems good enough for me.

>>> For sure, one rule we need to define is what criteria will be used
>>> to classify an application as something that will be
>>> compiled/installed by default, and what applications are
>>> development-oriented applications. On some cases, this is clear
>>> (for example, the API compliance test applications are
>>> developer-oriented, while libv4l is a standard user-oriented
>>> one). However, a debug application (like v4l2-dbg) is a development
>>> application, but it may be nice to have it available at the
>>> distros, to help users to help check/report problems).
>> Ack, I too think having v4l2-dbg available to end users could come
>> in very handy to remote debug stuff.
> 
> Indeed. Any tools that allow us to get insight would be great. Our
> current debugging tool belt is pretty poor in a lot of cases: lsusb,
> lspci, dmesg, "does cheese work"?
> 
>>> It may also be useful to define a minimum set of coding style, like
>>> how applications should be indented
> 
> Adopting Documentation/CodingStyle from the kernel with a few tweaks
> should work. That way we could use existing infrastructure like
> checkpatch.pl to check incoming stuff out.

Yes, but, as we have also non-c code, some rules there don't apply.
For example the rationale for not using // comments don't apply to c++, 
since it is there since the first definition.

> Shall we just go through and convert everything at once then? Bulk
> coding style conversions with cstyle, etc never works 100% and so
> someone will need to review the diffs by hand. Volunteers with
> experience doing that?

I have no strong opinion if we should or not convert the code to some
codingstyle, but, if we do, the better is to do everything at once.

>>> On the experiences we had with v4l-dvb tree, it is not a good idea
>>> to allow multiple people to commit at the master repository, since,
>>> when a conflict rises between two different developers, this can
>>> cause lots of heat. Also, it is easy to corrupt a tree, as a push
>>> with -f flag can remove (or hide, on -git) the objects inserted by
>>> someone else.
>>>
>> I've different experience in the projects with git I've used, as
>> long as there are some governance rules (like never ever push -f,
>> always do a rebase fix your stuff and then push, and if something
>> else got in in the window in between rebase again, etc.).
> 
> If the group of people with commit access is small (3-4) it generally
> works well.

Yes. The more people touching at the same tree, the more troubles may happen.

I don't object to allow a limited group of people accessing it, although
I suspect that, if we open to more than one, we will have more than 4 people
interested on it.

Cheers,
Mauro.

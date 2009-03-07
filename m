Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3105 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZCGIzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 03:55:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: saa7134 and RDS
Date: Sat, 7 Mar 2009 09:54:08 +0100
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl> <200903051736.44582.hverkuil@xs4all.nl> <20090307015506.GC3058@local>
In-Reply-To: <20090307015506.GC3058@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903070954.08696.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 March 2009 02:55:06 Hans J. Koch wrote:
> On Thu, Mar 05, 2009 at 05:36:44PM +0100, Hans Verkuil wrote:
> > On Thursday 05 March 2009 13:07:10 Hans Verkuil wrote:
> > > > Hi Hans
> > > >
> > > > I build fresh video4linux with your patch and my config for our
> > > > cards. In a dmesg i see : found RDS decoder.
> > > > cat /dev/radio0 give me some slow junk data. Is this RDS data??
> > > > Have you any tools for testing RDS?
> > > > I try build rdsd from Hans J. Koch, but build crashed with:
> > > >
> > > > rdshandler.cpp: In member function âvoid
> > > > std::RDShandler::delete_client(std::RDSclient*)â:
> > > > rdshandler.cpp:363: error: no matching function for call to
> > > > âfind(__gnu_cxx::__normal_iterator<std::RDSclient**,
> > > > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > > > __gnu_cxx::__normal_iterator<std::RDSclient**,
> > > > std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> > > > std::RDSclient*&)â
> > >
> > > Ah yes, that's right. I had to hack the C++ source to make this
> > > compile. I'll see if I can post a patch for this tonight.
> >
> > Attached is the diff that makes rdsd compile on my system.
>
> Great, thanks! The problem is, I really haven't got the time for RDS
> anymore. I simply cannot test your patch and check it in. From your
> previous contributions I know you as a competent and trustworthy v4l
> developer and would give you write access to the repository. Interested?

Erm, not really. When the API is finalized I want to make some sort of a 
simple reference utility/library for this and add it to v4l-dvb. To be 
honest, I think having a daemon just complicates matters unnecessarily.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

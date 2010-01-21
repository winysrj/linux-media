Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3595 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0AUHdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 02:33:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Brandon Philips <brandon@ifup.org>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Date: Thu, 21 Jan 2010 08:34:28 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org>
In-Reply-To: <20100121024605.GK4015@jenkins.home.ifup.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001210834.28112.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 21 January 2010 03:46:05 Brandon Philips wrote:
> On 00:07 Thu 21 Jan 2010, Mauro Carvalho Chehab wrote:
> > Brandon Philips wrote:
> > > On 19:50 Wed 20 Jan 2010, Hans de Goede wrote:
> > >> On 01/20/2010 04:41 PM, Mauro Carvalho Chehab wrote:
> > >>> As we're discussing about having a separate tree for v4l2-apps,
> > >>> maybe the better is to port it to -git (in a way that we can
> > >>> preserve the log history).
> > > 
> > > I have a small script I used to convert the history of libv4l to
> > > git. Let me know when we are ready to drop them from the hg tree
> > > and I can do the conversion and post the result for review.
> > > 
> > > This is the result from the script for just libv4l:
> > >  http://ifup.org/git/?p=libv4l.git;a=summary
> > 
> > Seems fine, but we need to import the entire v4l2-apps.
> 
> Yes, I know. I will run the script over v4l2-apps to generate a git
> repo once v4l2-apps is ready to be dropped from v4l-dvb mercurial and
> we figure out the directory layout.
> 
> Doing it before is just a waste of time since they will get out of
> sync.
> 
> > > Also, I suggest we call the repo v4lutils? In the spirit of
> > > usbutils, pciutils, etc.
> > 
> > Hmm... as dvb package is called as dvb-utils, it seems more logical to call it
> > v4l2-utils, but v4l2utils would equally work.
> 
> Yes, that is fine.
> 
> > IMO, the better is to use v4l2 instead of just v4l, to avoid causing
> > any mess with the old v4l applications provided with xawtv.
> 
> The problem I saw was that libv4l1 will be in v4l2-utils. I don't care
> either way though.
> 
> So here is how I see v4l-utils.git being laid out based on what others
> have said:
> 
>  libv4l1/
>  libv4l2/
>  libv4lconvert/
>  test/
>  v4l2-dbg/
>  contrib/
>   qv4l2-qt3/
>   qv4l2-qt4/
>   cx25821/
>   etc... everything else

Hmm. I think I would prefer to have a structure like this:

lib/
	libv4l1/
	libv4l2/
	libv4lconvert/
utils/
	v4l2-dbg
	v4l2-ctl
	cx18-ctl
	ivtv-ctl
contrib/
	test/
	everything else

And everything in lib and utils can be packaged by distros, while contrib
is not packaged.

What would also be nice is if this project http://v4l-test.sourceforge.net/
could eventually be merged in v4l2-apps.

> 
> Are there things in v4l2-apps that should be imported? 

I'm sorry, but I'm not sure what you mean.

Regards,

	Hans

> Other suggestions?
> 
> Cheers,
> 
> 	Brandon
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:58647 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0AUCqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 21:46:35 -0500
Received: by pxi12 with SMTP id 12so6186081pxi.33
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 18:46:34 -0800 (PST)
Date: Wed, 20 Jan 2010 18:46:05 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Message-ID: <20100121024605.GK4015@jenkins.home.ifup.org>
References: <4B55445A.10300@infradead.org>
 <201001190853.11050.hverkuil@xs4all.nl>
 <4B5592BF.8040201@infradead.org>
 <4B56C078.8000502@redhat.com>
 <12e7fb96118720cc47555e3a12a5fd53.squirrel@webmail.xs4all.nl>
 <4B57241E.2060107@infradead.org>
 <4B575068.8050105@redhat.com>
 <20100120210740.GJ4015@jenkins.home.ifup.org>
 <4B57B6E4.2070500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57B6E4.2070500@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 00:07 Thu 21 Jan 2010, Mauro Carvalho Chehab wrote:
> Brandon Philips wrote:
> > On 19:50 Wed 20 Jan 2010, Hans de Goede wrote:
> >> On 01/20/2010 04:41 PM, Mauro Carvalho Chehab wrote:
> >>> As we're discussing about having a separate tree for v4l2-apps,
> >>> maybe the better is to port it to -git (in a way that we can
> >>> preserve the log history).
> > 
> > I have a small script I used to convert the history of libv4l to
> > git. Let me know when we are ready to drop them from the hg tree
> > and I can do the conversion and post the result for review.
> > 
> > This is the result from the script for just libv4l:
> >  http://ifup.org/git/?p=libv4l.git;a=summary
> 
> Seems fine, but we need to import the entire v4l2-apps.

Yes, I know. I will run the script over v4l2-apps to generate a git
repo once v4l2-apps is ready to be dropped from v4l-dvb mercurial and
we figure out the directory layout.

Doing it before is just a waste of time since they will get out of
sync.

> > Also, I suggest we call the repo v4lutils? In the spirit of
> > usbutils, pciutils, etc.
> 
> Hmm... as dvb package is called as dvb-utils, it seems more logical to call it
> v4l2-utils, but v4l2utils would equally work.

Yes, that is fine.

> IMO, the better is to use v4l2 instead of just v4l, to avoid causing
> any mess with the old v4l applications provided with xawtv.

The problem I saw was that libv4l1 will be in v4l2-utils. I don't care
either way though.

So here is how I see v4l-utils.git being laid out based on what others
have said:

 libv4l1/
 libv4l2/
 libv4lconvert/
 test/
 v4l2-dbg/
 contrib/
  qv4l2-qt3/
  qv4l2-qt4/
  cx25821/
  etc... everything else

Are there things in v4l2-apps that should be imported? Other suggestions?

Cheers,

	Brandon

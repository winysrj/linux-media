Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZBUCSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 21:18:49 -0500
Date: Fri, 20 Feb 2009 23:18:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kilgota@banach.math.auburn.edu
Cc: Jean Delvare <khali@linux-fr.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090220231820.67ce2899@pedra.chehab.org>
In-Reply-To: <alpine.LNX.2.00.0902201853040.9018@banach.math.auburn.edu>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218071041.63c09ba3@pedra.chehab.org>
	<20090218140105.17c86bcb@hyperion.delvare>
	<20090220212327.410a298b@pedra.chehab.org>
	<alpine.LNX.2.00.0902201853040.9018@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Theodore,

On Fri, 20 Feb 2009 19:30:16 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> Hoping that I can offer some helpful comments on this thread, as someone 
> who came along only in the last couple of months or so:
> 
> 1. One of the most interesting features which I found in the video for 
> Linux project is the ability to work somewhat independently of the 
> particular kernel version running on the local machine. This is valuable, 
> in the sense that it saves a lot of wasted time and effort just keeping up 
> with which kernel version to use. It was also something which is done so 
> cleverly that at first I could not believe it. Congratulations to those 
> who thought this arrangement up.
> 
> 2. Sometimes, there is a real problem with a particular version of the 
> kernel which has nothing to do with the task at hand, but it sure can get 
> in the way. As a recent example, soon after starting to work with Adam 
> Baker on the sq905 module (and furthermore having at the time the false 
> impression that the gspca work meant I should be running the latest thing 
> out there) I upgraded from 2.6.27.7 to 2.6.28. Well, there was a rather 
> serious USB bug in 2.6.28. So then _that_ had to be straightened out. 
> Things like that do not promote smooth progress but rather interfere with 
> it.
> 
> 3. I just bought an eeePC. It is running some 2.6.21.x kernel. My 
> reaction: I do not believe they should be doing that. I would not feel 
> like accommodating them. Comparison: someone wrote to me complaining about 
> problems with libgphoto2-2.1.3, which his distro was still releasing, when 
> libgphoto2-2.3.x was already out and his problem had been solved 24 months 
> before. I told him to upgrade and his problems would go away. He wanted me 
> to fix his old version. I explained that this has been done, and he should 
> avail himself of that by installing a new version. Somewhere there is a 
> line, and that guy crossed it.
> 
> Trying to put all this together:
> 
> I think that the semi-independence from the particular kernel-du-jour is a 
> good thing and would seem to me to make progress in the specific area of 
> video to be smoother. Modular or semi-modular development is something 
> nice. One can concentrate on the subject at hand and not on daily kernel 
> upgrading. Nice.
> 
> I also would not want to bust my butt to support someone's ancient kernel. 
> After all, quite often the reason there is a new kernel version is that 
> some long-undiscovered bug suddenly got discovered. Not all change is 
> just for fun, or just to support new stuff. Some of those bugs had 
> far-reaching consequences, recall. So to support one of the affected 
> kernels involves what, exactly?
> 
> Hoping that these comments help toward some good conclusion of this issue.

Thank you for your comments.

For sure allowing to compile v4l-dvb with older kernels is very interesting for
the users. It is not perfect, since a bug upstream will keep affecting the
backported driver, but, in general, this works well, however, at the cost of
spending developers time backporting things. Since the size of the tree is
increasing a lot, we'll likely need to use another solution.


Cheers,
Mauro

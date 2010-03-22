Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:36407 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0CVONo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 10:13:44 -0400
Date: Mon, 22 Mar 2010 09:37:23 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
In-Reply-To: <4BA73865.3070107@redhat.com>
Message-ID: <alpine.LNX.2.00.1003220925140.9050@banach.math.auburn.edu>
References: <201003200958.49649.hverkuil@xs4all.nl> <201003212345.04736.hverkuil@xs4all.nl> <201003220117.34790.hverkuil@xs4all.nl> <4BA73865.3070107@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 22 Mar 2010, Hans de Goede wrote:

<snip>


> 
> [...] I've seen the same 
> problem (not streaming) with the "old" version when used with machines 
> with UHCI usb controllers (rather then OHCI), such as atom based 
> laptops.
> 
> So maybe this is some timing issues, and your changes have speed up some 
> path?

Sorry to break into a very interesting discussion which I was otherwise 
just watching. But how many other cases of this kind of UHCI versus OHCI 
kind of thing has anyone else witnessed?

Recall, we faced exactly the same situation in developing the current 
version of the mr97310a driver? That I was doing everything on an OHCI 
machine and then, at the very last step I tested on a UHCI machine and 
suddenly some of the cameras would not work? And there was one magic 
command to the camera which "fixed" the problem and we still don't know 
why that one magic command fixed the problem, only that the fix is very 
critical, very necessary, and it does work?

Please, anyone who can report similar mysterious events, let me know. I 
would still like to get to the bottom of what is going on, if I can.

Sorry for the interruption. Anyone who is interested in pursuing this, 
start a new thread if you want.

Theodore Kilgore

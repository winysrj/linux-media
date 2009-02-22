Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:48652 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZBVWfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 17:35:45 -0500
Date: Sun, 22 Feb 2009 16:47:31 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <49A1CA5B.5000407@redhat.com>
Message-ID: <alpine.LNX.2.00.0902221635440.10870@banach.math.auburn.edu>
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu> <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu>
 <49A1CA5B.5000407@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 22 Feb 2009, Hans de Goede wrote:

<big snip>

> Yes that is what we are talking about, the camera having a gravity switch 
> (usually nothing as advanced as a gyroscope). Also the bits we are talking 
> about are in a struct which communicates information one way, from the camera 
> to userspace, so there is no way to clear the bits to make the camera do 
> something.
>
> Regards,
>
> Hans

Well, of course the bits are in a struct which is communicates information 
one way from the camera to userspace. But userspace can do what it deems 
appropriate with those bits. My point was that if userspace wants to turn 
the camera upside down in software, all it has to do is to negate those 
bits. For that purpose, it does not matter whether the bits were 
originally set "on" (indicating that the sensor is upside down in the 
camera) or whether they were set "off" (indicating the sensor is right 
side up in the camera). Now, if it is a question of passing along a 
changing camera orientation, it is obvious that has to be done with some 
other mechanism. So, unless my not terribly profound observation about 
the ability to negate bits was confusing, we are not in disagreement.

Theodore Kilgore

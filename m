Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbZBVW4h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 17:56:37 -0500
Message-ID: <49A1D7B2.5070601@redhat.com>
Date: Sun, 22 Feb 2009 23:54:42 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com> <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu> <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu> <49A1CA5B.5000407@redhat.com> <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Trent Piepho wrote:
> On Sun, 22 Feb 2009, Hans de Goede wrote:
>> Yes that is what we are talking about, the camera having a gravity switch
>> (usually nothing as advanced as a gyroscope). Also the bits we are talking
>> about are in a struct which communicates information one way, from the camera
>> to userspace, so there is no way to clear the bits to make the camera do something.
> 
> First, I'd like to say I agree with most that the installed orientation of
> the camera sensor really is a different concept than the current value of a
> gravity sensor.  It's not necessary, and maybe not even desirable, to
> handle them in the same way.
> 
> I do not see the advantage of using reserved bits instead of controls.
> 
> The are a limited number of reserved bits.  In some structures there are
> only a few left.  They will run out.  Then what?  Packing non-standard
> sensor attributes and camera sensor meta-data into a few reserved bits is
> not a sustainable policy.
> 
> Controls on the other card are not limited and won't run out.
> 

Yes but these things are *not* controls, end of discussion. The control API is 
for controls, not to stuff all kind of cruft in.

Regards,

Hans

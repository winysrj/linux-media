Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZBPI0A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 03:26:00 -0500
Message-ID: <49992418.3020903@redhat.com>
Date: Mon, 16 Feb 2009 09:30:16 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
References: <200902142048.51863.linux@baker-net.org.uk> <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com> <200902151019.35555.hverkuil@xs4all.nl> <4997E05F.9080509@redhat.com> <Pine.LNX.4.58.0902150445490.24268@shell2.speakeasy.net> <49981C9F.7000305@redhat.com> <Pine.LNX.4.58.0902151506220.24268@shell2.speakeasy.net> <alpine.LNX.2.00.0902151844340.1496@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902151844340.1496@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 

<huge snip>

> Therefore,
> 
> 1. Everyone seems to agree that the kernel module itself is not going to 
> do things like rotate or flip data even if a given supported device 
> always needs that done.
> 
> However, this decision has a consequence:
> 
> 2. Therefore, the module must send the information about what is needed 
> out of the module, to whatever place is going to deal with it. 
> Information which is known to the module but unknown anywere else must 
> be transmitted somehow.
> 
> Now there is a further consequence:
> 
> 3. In view of (1) and (2) there has to be a way agreed upon for the 
> module to pass the relevant information onward.
> 
> It is precisely on item 3 that we are stuck right now. There is an 
> immediate need, not a theoretical need but an immediate need. However, 
> there is no agreed-upon method or convention for communication.
> 

We are no longer stuck here, the general agreement is adding 2 new buffer 
flags, one to indicate the driver knows the data in the buffer is
vflipped and one for hflip. Then we can handle v-flipped, h-flipped and 180 
degrees cameras

This is agreed up on, Trent is arguing we may need more flags in the future, 
but that is something for the future, all we need know is these 2 flags and 
Hans Verkuil who AFAIK was the only one objecting to doing this with buffer 
flags has agreed this is the best solution.

So Adam, kilgota, please ignore the rest of this thread and move forward with 
the driver, just add the necessary buffer flags to videodev2.h as part of your 
patch (It is usually to submit new API stuff with the same patch which 
introduces the first users of this API.

I welcome libv4l patches to use these flags.

Regards,

Hans

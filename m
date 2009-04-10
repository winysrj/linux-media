Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:46455 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765188AbZDJR0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 13:26:52 -0400
Date: Fri, 10 Apr 2009 12:39:31 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	Mauro Carvalho Chehab <mchehab@infrade4ad.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be
cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@ssamsung.com"@banach.math.auburn.edu,
	jongse.won@samsung.com, riverful.kim@samsung.com
Subject: Re: [RFC] White Balance control for digital camera
In-Reply-To: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0904101217260.4270@banach.math.auburn.edu>
References: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 10 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> Hello everyone,
>
> I'm posting this RFC one more time because it seems to everyone has
> been forgot this, and I'll be appreciated if any of you who is reading
> this mailing list give me comment.

I don't know much about the topic, and I wish I did.

> I've got a big question popping up handling white balance with
> V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.
>
> Because in digital camera we generally control over user interface
> with pre-defined white balance name. I mean, user controls white
> balance with presets not with kelvin number.
> I'm very certain that TEMPERATURE CID is needed in many of video
> capture devices, but also 100% sure that white balance preset control
> is also necessary for digital cameras.
> How can we control white balance through preset name with existing V4L2 API?

Let's broaden the question to include digital still cameras, which present 
similar problems. They present data related to this kind of thing, that is 
obvious. But are there any standard meanings to what is there? Do you know 
anything about that? Can you help?

Two examples:

The SQ905 and SQ905C cameras in stillcam mode use an allocation table, 
which presents on each line some data about the given image. In this line, 
byte 0 is a one-byte code for pixel dimensions and compression setting. 
Then some more bytes give the starting and ending locations of the photo 
in the camera's memory (actually irrelevant and superfluous information, 
because you can only ask for the photos in sequence, and with a command 
which has nothing to do with its memory location at all). Then some more 
bytes obviously have something to do with contrast, brightness, white 
balance, color balance, and so on. But I have no more idea than the Man in 
the Moon how those bytes are supposed to be interpreted. The SQ905 gives 
no such equivalent information while in streaming mode, and so there is 
nothing at all which could be done with the nonexistent information. But 
the SQ905C does obviously give such information, in a few bytes in the 
header of each frame.

The MR97310A cameras give similar information in the header of the photo 
itself (and in this case the camera does the same thing in webcam mode, 
too). Again, I have no idea either what these mysterious bytes are 
supposed to mean, and how to use them constructively.

I could mention several other examples, too, but these will do for a 
start.

Are there any agreed-upon standards about this kind of thing, in the 
camera industry? Is there any source of information about it?

Theodore Kilgore

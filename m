Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:60588
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbZBQW3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 17:29:52 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Adding a control for Sensor Orientation
Date: Tue, 17 Feb 2009 22:29:48 +0000
Cc: kilgota@banach.math.auburn.edu,
	Hans de Goede <hdegoede@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <59373.62.70.2.252.1234773218.squirrel@webmail.xs4all.nl> <alpine.LNX.2.00.0902161817430.3019@banach.math.auburn.edu> <200902170827.21221.hverkuil@xs4all.nl>
In-Reply-To: <200902170827.21221.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902172229.48533.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 February 2009, Hans Verkuil wrote:
<snip>
> The tentative conclusion was that putting it in the v4l2_input
> struct was a good idea.

I'm not sure I'd go as far as to call it even a tentative conclusion.

I think the biggest stumbling block for now is how to handle Olivier Lorin's 
bi-directional camera case.

<snip>
>
> Actually, support for a lot of the cheap webcams is relatively new to the
> kernel. For a long time it was maintained outside the tree. So I'm not
> surprised that came up fairly late in the game.
>

Yes, it's only the advent of libv4l that finally makes pulling all these 
drivers into the kernel viable as before that they all had to break the rules 
and have in kernel format translation from their obscure formats to something 
widely recognized to be useful. (I speak here as someone who has been 
maintaining such a driver out of kernel for a few years)

> And everyone agrees with the need to solve the issue you have. There was
> just the question of were to store that information.
>
> Whoever is pushing this change (you? Adam Baker? I must admit I'm not sure)
> should write a small RFC with possible solutions and pros and cons, post
> it, and when a consensus is reached make a test implementation, see if it
> works and then post the patches with the change. This RFC should only
> address the mount position, not pivoting or USB tables. Those are separate
> issues.

Hans de Geode and Olivier Lorin both posted RFCs on the subject which failed 
to attract the interest that this thread has so I was hoping to reach a 
conclusion here while there is still some momentum to peoples thoughts but 
if you think a new thread that starts with a summary of this one is the best 
way to proceed then I'm happy to start it.

>
> I find it much more productive to use RFCs for API changes/additions, it
> keeps things more focused.

Adam

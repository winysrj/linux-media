Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:47744 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2EVVC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 17:02:26 -0400
Date: Tue, 22 May 2012 23:02:14 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Paulo Assis <pj.assis@gmail.com>,
	=?ISO-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
	linux-media@vger.kernel.org
Subject: Re: Problems with the gspca_ov519 driver
Message-Id: <20120522230214.700ec32864670a7813260577@studenti.unina.it>
In-Reply-To: <4FBBA515.7010006@redhat.com>
References: <20120522110018.GX1927@vicerveza.homeunix.net>
	<CAPueXH6uN4UQO_WL_pc9wBoZV=v_7AVtQKcruKY=BCMeJOw-2Q@mail.gmail.com>
	<4FBBA515.7010006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 22 May 2012 16:39:17 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> On 05/22/2012 04:08 PM, Paulo Assis wrote:
> > Hi,
> > This bug also causes the camera to crash when changing fps in
> > guvcview, uvc devices (at least all the ones I tested) require the
> > stream to be restarted for fps to change, so in the case of this
> > driver after STREAMOFF the camera just becomes unresponsive.
> >

[...]
> > 2012/5/22 Lluís Batlle i Rossell<viric@viric.name>:
> >> Hello,
> >>
> >> I'm trying to get video using v4l2 ioctls from a gspca_ov519 camera, and after
> >> STREAMOFF all buffers are still flagged as QUEUED, and QBUF fails.  DQBUF also
> >> fails (blocking for a 3 sec timeout), after streamoff. So I'm stuck, after
> >> STREAMOFF, unable to get pictures coming in again. (Linux 3.3.5).
> >>

[...]
> We talked about this on irc, attached it a patch which should fix this, feedback
> appreciated.
> 

Thanks HdG.

Paulo, this seems to fix the problem I too was having when changing the
framerate on ov534 with guvcview.

IIRC, from a previous investigation, I've been experiencing this since
commit f7059ea, which in fact removes the lines HdG added back, but I
didn't put too much effort in investigating the exact cause, sorry.

For the record the guvcview error messages were:

VIDIOC_QBUF - Unable to queue buffer: Invalid argument
 Could not grab image (select timeout): Resource temporarily unavailable

I feel I can add a:

Tested-by: Antonio Ospite <ospite@studenti.unina.it>

I can backport the change to older kernels and even CC linux-stable if
you think it is appropriate, that's the least I can do to expiate for
knowing about a bug/regression and not hunting its cause hard enough.

HdG maybe you could mention f7059ea in the commit message of this fix
if you can confirm the problem was introduced there.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

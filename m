Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:51426 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab2ERLiI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 07:38:08 -0400
Date: Fri, 18 May 2012 13:38:04 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/3] gspca: kinect cleanup, ov534 port to control
 framework
Message-Id: <20120518133804.2fefb23f0522a80fce3662d4@studenti.unina.it>
In-Reply-To: <20120518090829.292bd671@tele>
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
	<20120518090829.292bd671@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 May 2012 09:08:29 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 16 May 2012 23:42:43 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
> > The second patch removes the dependency between auto gain and auto white
> > balance, I'd like to hear Jean-Francois on this, the webcam (the ov772x
> > sensor) is able to set the two parameters independently and the user can
> > see the difference of either, is there a reason why we were preventing
> > the user from doing so before?
> 
> Hi Antonio,
> 
> I added this dependency by the git commit 2d19a2c1186d86e3
> on Thu, 12 Nov 2009 (the original patch was done under mercurial).
> 
> Looking in my archives, I retrieved this mail I have sent to you,
> Max Thrun, kaswy, baptiste_lemarie, Martin Drake and Jim Paris:

[...]
> > > > > *  * AWB doesn't have any effect?*
> > > > >  
> > > > I notice its effect if i start uvcview, enable auto gain, then
> > > > enable awb.
> > > >  
> > > 
> > > If there is a strict dependency between these two settings,
> > > shouldn't the driver enforce it?  

Here I made a wrong assumption at the time, the bug must have been
somewhere else, forgive the "younger me" in that email :)

> Otherwise, you are right, the ov7670 and ov7729 datasheets do not talk
> about a possible AGC and AWB dependency...

OK, thanks.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

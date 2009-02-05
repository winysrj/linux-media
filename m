Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:53953 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZBEUAC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 15:00:02 -0500
Date: Thu, 5 Feb 2009 20:51:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: kilgota@banach.math.auburn.edu
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
Message-ID: <20090205205129.1b412241@free.fr>
In-Reply-To: <alpine.LNX.2.00.0902051237400.5068@banach.math.auburn.edu>
References: <200902032313.17538.linux@baker-net.org.uk>
	<20090204174008.31846f22@free.fr>
	<200902042207.44867.linux@baker-net.org.uk>
	<20090205123947.0ba06e44@free.fr>
	<alpine.LNX.2.00.0902051237400.5068@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Feb 2009 12:59:21 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> 
> 
> On Thu, 5 Feb 2009, Jean-Francois Moine wrote:
> 
> > On Wed, 4 Feb 2009 22:07:44 +0000
> > Adam Baker <linux@baker-net.org.uk> wrote:
> >
> >> Thank You - If it wasn't for your work on gspca I'd still be using
> >> a buggy old driver that had no chance of making it to main line.
> 
> Well, I would not have been using it, actually. It was too much of a
> mess. As to the "thanks" I definitely second that. To put together
> over-arching projects which provide an API and a context for doing
> things like this is definitely the way to go, and this one has been
> put together with some thought, over a period of time. This brings up
> a question I have been nmeaning to ask for some time: Whie we are
> thanking people, it does occur to me to ask what has happened to
> Michel Xhaard. We used to correspond occasionally. We had different
> interests, with some intersection. I was specializing in still
> cameras, and he was doing the webcam project from which gspca has
> evolved. Our common interesection of interests, of course, were about
> such matters as decompression algorithms, as well as pointing each
> other to new cameras to look at. But the last time I sent Michel an
> e-mail, which was about a two months ago or so, I did not get any
> answer.

Same for me. Since 6 months, he did answer only one time, on the list...
I cannot even know if he is glad to have his baby in the Linux kernel.

> > OK. It seems everything works fine with your webcam(s) (and the
> > other ones).
	[snip]
> Just to be clear about this:
> 
> Jean-Francois, you sent out a separate mail about doing a pull,
> which, I assume contains the changes in gspca which you mention
> above, So, what you want now is a few minor revisions in the sq905
> module, in accordance with what is above, and then some final testing.
	[snip]

Yes. As I said before, I'm ready to insert your driver in the gspca
tree. The basic streaming is working. The video controls and the
other resolutions may be added later.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

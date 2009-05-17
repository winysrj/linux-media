Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp9.trip.net ([216.139.64.9]:51405 "EHLO smtp9.trip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZEQQKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 12:10:32 -0400
Date: Sun, 17 May 2009 12:08:30 -0400
From: MK <halfcountplus@intergate.com>
Subject: Re: working on webcam driver
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Erik =?iso-8859-1?q?Andr=E9n?= <erik.andren@gmail.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu>
	(from kilgota@banach.math.auburn.edu on Thu May 14 15:57:07 2009)
Message-Id: <1242576510.1986.0@lhost.ldomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks much for the feedback!  Here's what happened:

Because the vendor id (0c45) is listed by the gspca website but not 
the product (612a), I decided to try inserting the id into one of the 
drivers/media/video/gspca.  When I actually grepped (had not grepped 
the tree itself yet), low and behold 612a is in sonixj.  The module 
compiles and responds to the camera, although the results in gstreamer, 
et. al, are disappointing -- the camera is not really usable, I suspect 
from the output it is the kernel driver, but I am not sure.  Since I 
didn't write this stuff, I think working alone it will be more trouble 
than it is worth to track the problem down, esp. if this is mostly a 
problem with an (obscure) inexpensive item that few linux users 
actually possess.

So, I am going to cut my "loses" early on this project and cop out.  
I've learned a bunch about the kernel and in the process written some 
nifty little char drivers that are probably more useful to me than a 
webcam anyway. I think my time would be better spent on other things, 
eg, I might become useful in someone else's (more significant) linux 
kernel/driver project.  I will have a look around.

But thanks again!  You were much nicer than mr Greg Kroah-Hartman ;) :0

Sincerely, Mark Eriksen (getting his feet wet)



Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58356 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZC1Tz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 15:55:56 -0400
Date: Sat, 28 Mar 2009 15:08:55 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: linux-media@vger.kernel.org
Subject: A question about Documentation/video4linux/gspca.txt
In-Reply-To: <20090327200106.7cae9bec@free.fr>
Message-ID: <alpine.LNX.2.00.0903281437310.4041@banach.math.auburn.edu>
References: <1238170102.3791.8.camel@tux.localhost> <20090327200106.7cae9bec@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I notice that sq905.c and sq905c.c have now been added to the gspca tree.

But now a question about the documentation. None of that has been 
addressed, as yet, neither for the sq905 nor for the sq905c cameras. The 
code has been added to the tree, but the accompanying documentation 
is, as yet, missing. I would be glad to provide it, but it seems to me 
that a policy question comes up, about just what to add. There are lots of 
cameras.


Here is the problem:

The sq905 module supports, as far as I know, the entire list of cameras 
which are supported by libgphoto2/camlibs/sq905, and probably more which I 
did not list there because I got tired of adding yet another camera when, 
in fact, functionally they were all pretty much equivalent (My bad. I 
know that I missed a few of them, but I was more inexperienced back 
then). In any event, the support for 24 cameras is explicitly listed 
there.

The sq905c module supports, as far as I know, the entire list of cameras 
which are supported by libgphoto2/camlibs/digigr8. The support for 16 
cameras (or 17, if the line in libgphoto2/camlibs/digigr8/library.c 
"Sakar 28290 and 28292  Digital Concepts Styleshot"
which refers to two cameras differing only in the color of the case 
is counted as referring to two cameras).

Thus, if the documentation would be provided in 
linux/Documentation/video4linux/gspca.txt it would amount to a total of 41 
new entries, for these two new modules alone. Should all 41 of them be 
added? I would think that they all ought to be listed somewhere, but 
should the somewhere be there, or somewhere else? That is the question.

One possibility might be to refer the curious reader to the existing list 
in the relevant file in libgphoto2, for example, since these are all 
dual-mode cameras. If that were done, then it would be only needed to put 
the USB Vendor:Product number into the gspca.txt file, along with a 
pointer to the full information.

Theodore Kilgore

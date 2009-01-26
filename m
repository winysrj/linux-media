Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53148 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZAZSri (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 13:47:38 -0500
Date: Mon, 26 Jan 2009 12:59:21 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Antti Palosaari <crope@iki.fi>
cc: linux-media@vger.kernel.org
Subject: Re: Any project to offer for summer code Finland
In-Reply-To: <497DF48F.9@iki.fi>
Message-ID: <alpine.LNX.2.00.0901261227130.19178@banach.math.auburn.edu>
References: <497DF48F.9@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 26 Jan 2009, Antti Palosaari wrote:

> Hello
> Is there any good project idea for summer code?
>
> coss.fi offers Finnish students paid summer job for open source projects. 
> Project duration is three months of work.
>
> I wonder if there is some tools or libraries missing from dvb-apps example.
>
> Antti
> -- 
> http://palosaari.fi/
> --

Hello,

I only subscribed recently to the v4l list, myself. I have long-time 
interests in digital camera support for Linux, and I have been a long-time 
participant in the Gphoto project. I have written several camera driver 
libraries for libgphoto2 and continue to maintain them. In my opinion, 
there are several things which are badly needed. Some of them may not be 
feasible topics for a summer student project, but on the other hand some 
of them may. I can suggest two items.

1. The biggest problem in USB digital camera support is to be confronted 
with a proprietary data compression algorithm about which no information 
is easily available. Any progress with this problem would be helpful. For 
example, work on the decompression algorithm for one of several cameras 
which need this work done right now. However, a better topic for a student 
project might be the development of some kind of toolkit which would 
streamline the work on such a vexing problem. Probably, nobody will want 
to tackle this one, but I remind whoever reads this that the problem is 
very much present.

2. As related to V4L camera support in particular, there is the problem of 
Bayer demosaicing. The current state of affairs is that raw bitmap data is 
interpolated using the old method of bilinear interpolation. The results 
are sometimes (quite expectedly) very ugly, with lots of artifacts at 
edges in the output. Better methods exist for use in still cameras. For 
example, in libgphoto2 there is a standard method which involves bilinear 
interpolation with minor improvements, involving a simple edge detection 
scheme. I was responsible for putting that edge detection scheme into the 
code, several years ago. I was also responsible for putting in the code a 
new algorithm, which is based on a simplification of the well known 
Adaptive Homogeneity-Directed algorithm. This code, found in libgphoto2 in 
the file ahd_bayer.c was written last year as a joint student project with 
a student named Eero Salminen at Helsinki University of Technology. Eero 
was studying under professor Jorma Laaksonen.

Now, the problem for using the results of last year's work for libgphoto2 
in V4L is the obvious issue of speed. The code for libgphoto2 is intended 
for still cameras, and the relative slowness of the code does not affect 
the question of frame rate for streaming. But for a videocam or a webcam 
this is an obvious problem. At the same time, it appears to me that there 
ought to be a way to improve the Bayer demosaicing code in the V4L 
libraries so that it gives better results without such a hit on speed. For 
that matter, I am sure that the code in libgphoto2 could be improved in 
this respect, too. The speed is not a factor there, to be sure, but it 
might still be helpful to make it faster and, at the same time, to reduce 
the memory footprint of that code. A great portion of our joint efforts 
last year was in the direction of doing just that, but further progress is 
still possible.

I would be very glad to work with someone on a project involving either 
item 1 or item 2. The idea of such work being related to academic work and 
research also appeals to me very much, as you can see below.

Theodore Kilgore
Department of Mathematics and Statistics
Auburn University, Alabama

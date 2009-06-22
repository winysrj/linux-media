Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51997 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZFVDYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 23:24:37 -0400
Date: Sun, 21 Jun 2009 22:39:28 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245634667.3815.54.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906212230200.31693@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>  <1245525813.3178.24.camel@palomino.walls.org>  <1245538316.3296.36.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu>  <1245557957.3296.215.camel@palomino.walls.org>  <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu> <1245634667.3815.54.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Andy,

You are right. Your camera is emitting JPEG while streaming. I just 
succeeded in creating an image which resembles your test picture by 
extracting the frame data for one frame, tacking on a header, and running 
hex2bin on the combined file. I did not get the thing quite right, because 
your header is from your JPEG photo (640x480) and your stream is probably 
320x240. But I got something out which is obviously recognizable. 
Therefore with a little bit of further tweaking it will presumably come 
out exactly so. Namely, I have to remember where to stick the two 
dimensions into the header. As my students in courses like calculus say, 
"Sir, it has been a long time since I studied that." Whereupon I reply, 
"With my white hair, I wonder how far I could get with that excuse?"

I will send you a copy of the results for your amusement. It is obviously 
the first attempt, so do not laugh at the fact that you get two copies of

 	 3
 	x6
 	--

side by side, please.

Theodore Kilgore

Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57998 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFVXmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 19:42:50 -0400
Date: Mon, 22 Jun 2009 18:57:45 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245670060.3178.14.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906221840170.24027@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>  <1245525813.3178.24.camel@palomino.walls.org>  <1245538316.3296.36.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu>  <1245557957.3296.215.camel@palomino.walls.org>  <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>  <1245634667.3815.54.camel@palomino.walls.org>  <alpine.LNX.2.00.0906212230200.31693@banach.math.auburn.edu>
 <1245670060.3178.14.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


<snip>

>> Therefore with a little bit of further tweaking it will presumably come
>> out exactly so. Namely, I have to remember where to stick the two
>> dimensions into the header.

Today's progress, so far:

1. I managed to look up where the width and height go, and indeed the 
image comes out nicely when the dimensions are appropriately entered.

2. The same header that I peeled off from your JPEG image also works for 
images from my cam. That is, I took your header, converted to text, and 
corrected the dimensions. Then I took a frame extracted from the snoop log 
of my camera, prepended it with your header, and I get a recognizable 
image. I really should try the same with a header from my own camera, of 
course. For one thing, the image was recognizable but not beautiful, and 
it occurs to me as I write that there might be some problem other than, 
perhaps, an unlucky choice of frame. But we do have a demonstration that 
there is some high degree of compatibility.

Finally, I succeeded in creating a couple of AVI files. There is one 
difference between the two AVI headers. Yours has

Jeilin  Technology Co., Ltd.JL2008V2C0070010

and mine has only

Jeilin  Technology Co.

So what is the version of my camera? They don't say, and therefore I still 
don't know. We can hope it does not matter very much.

I will have a go at writing a module for them, and we can see what happens 
after that.

Theodore Kilgore

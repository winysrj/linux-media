Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51229 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZFUQ5k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 12:57:40 -0400
Date: Sun, 21 Jun 2009 12:12:32 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Sakar 57379 USB Digital Video Camera...
In-Reply-To: <1245557957.3296.215.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906211154280.31296@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>  <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>  <1245386416.20630.31.camel@palomino.walls.org>  <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>  <1245435414.4181.7.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>  <1245462845.3168.40.camel@palomino.walls.org>  <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>  <1245525813.3178.24.camel@palomino.walls.org>  <1245538316.3296.36.camel@palomino.walls.org>
  <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu> <1245557957.3296.215.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I mentioned in my last message a couple of things to try in order to make 
further progress. One of those was

2. Take some of the snoop log output and convert it by hand to a binary
file, so that it can actually be looked at with hexdump to see if similar
clues are present. I have a few tools that, while not making this 
automatic, do make the job not too too unpleasant.

So, I have implemented this one. That is, I have removed everything other 
than frame data from your log file, and from mine. After that, I have 
converted said frame data to binary, using a program called "hex2bin" 
that I found several years ago (see footnote).

After that, I have done hexdump -C to the result in order to see if any 
interesting text becomes visible.


What I have to report is:

No detectable text patterns, neither in the raw data output from your 
camera, nor from mine. It appears to me that we have nothing there but raw 
data and the camera-specific frame headers which we have already figured 
out are there.

(footnote)
  The program was in source form, and carries the following notice

/*

hex2bin.c    reverse hexdump

Copyright (c) 1996 by   Andreas Leitgeb (AvL) <avl@logic.tuwien.ac.at>

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation.

*/

Probably nobody on a list like this one needs a thing like this, but just 
in case that anyone does, I just checked with Google for hex2bin.c and 
this one comes up as the second hit. I have used it on previous occasions, 
and it seems to work nicely.

(end footnote)

Theodore Kilgore

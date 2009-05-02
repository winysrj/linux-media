Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44932 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZEBBeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 21:34:17 -0400
Date: Fri, 1 May 2009 20:47:57 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Progress with the MR97310A "CIF" cameras
In-Reply-To: <alpine.LNX.2.00.0904151850240.9310@banach.math.auburn.edu>
Message-ID: <alpine.LNX.2.00.0905012026360.28590@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu>
 <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu> <49AFCD5B.4050100@kaiser-linux.li> <alpine.LNX.2.00.0904151850240.9310@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


by which I am referring to the cameras with ID 0x093a:0x010e :

At first it seemed to me that these cameras were using a 
different compression algorithm, because the current code in 
gspca/mr97310a.c failed to produce viewable frames while streaming, only 
junk.

However, the above seems not to be true. I finally got an old Win2k box 
going again, installed the driver, and got a sniff of the initialization 
sequence. It is quite different from the one which is in use for the 
larger cameras. But only the initialization is different, not the 
compression.

At this point I can definitely say that replacement of the initialization 
sequence in the existing sd_start() function in gspca/mr97310a.c by the 
initialization sequence which I got from the sniff log seems to make the 
test camera to run just fine.

What is still left to do is to see what comes out of the Elta camera which 
you (Thomas) are supposed to receive in the mail. For, interestingly, not 
all of these cameras seem to be doing the same thing. I have tested at 
least two others, on the Win2k machine, and they do not stream at all. Or, 
rather, they will go through the motions but the entire streaming 
activity, according to the log file, is to send repetitions of the SOF 
marker and frame header until one gets tired and quits. It may be that the 
init sequence for those two cameras is still a different one, and I do not 
have the old driver CDs because I thought they all have to be identical. 
Or perhaps they were never intended to stream.


In any event, one of the cameras is working now, an Innovage Mini Digital 
Camera. The Philips Digital Keychain camera will not stream, and neither 
will the Vivitar Mini. Since the Vivitar Mini does not support compression 
of still photos at all, it may be that it simply does not have the 
firmware to do the compression. The Philips camera, however, is a 
surprise.

I look forward with anticipation to learn what the initialization sequence 
is from the Elta camera, since we already have testimony that it will do 
streaming.

Then I guess I get busy rewriting the mr97310a.c code so that it will 
support the two different kinds of cameras ...

Thomas, sorry that we do not have a world to conquer in regard to a 
decompression algorithm. But it seems that this time we do not.

Theodore Kilgore

Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55401 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZBEVmq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 16:42:46 -0500
Date: Thu, 5 Feb 2009 15:54:40 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
In-Reply-To: <20090205205129.1b412241@free.fr>
Message-ID: <alpine.LNX.2.00.0902051440030.5236@banach.math.auburn.edu>
References: <200902032313.17538.linux@baker-net.org.uk> <20090204174008.31846f22@free.fr> <200902042207.44867.linux@baker-net.org.uk> <20090205123947.0ba06e44@free.fr> <alpine.LNX.2.00.0902051237400.5068@banach.math.auburn.edu>
 <20090205205129.1b412241@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Feb 2009, Jean-Francois Moine wrote:

> On Thu, 5 Feb 2009 12:59:21 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:

<snip>

> [,,,] As I said before, I'm ready to insert your driver in the gspca
> tree. The basic streaming is working. The video controls and the
> other resolutions may be added later.

In fact, the ability to change the resolution is not exactly documented. 
No OEM driver that I know of ever did offer such a choice. They all just 
stream at 320x240, with no exceptions. I discovered this ability not from 
sniff logs, but by running experiments of my own. After that, my 
"documentation" consists pretty much of just mentioning it on the 
gphoto-devel mailing list if someone wrote in and asked if it is possible 
or not. I never felt safe using that information in the libgphoto2 driver, 
though. The problem was that some of the cams will only do max 352x288 and 
some will do max 640x480. But I could not figure out a way to tell the 
cameras apart. Still photos are listed in an allocation table which makes 
such things clear, for each individual photo. With streaming there is no 
equivalent to that. Even worse, in a way, is that the lower-res camera 
will go ahead and shoot a frame if you ask for a 640x480 but you will get 
a lower resolution instead. An obvious mess.

It was only while we are working here that I began to see a pattern 
relating the ID string to the ability to do 640x480. If you want to know, 
that ID looks like 09 05 00 xx and sometimes like 09 05 01 xx and 
sometimes like 09 05 02 xx. I am pretty sure now that, if the third byte 
in the string is not zero then the camera can do 640x380.

However, even now I can not be 100% certain. The SQ905 was, at one time, a 
very popular chip for cheap cameras. I can not even count the number of 
brand names and models in which it was used, or in which countries they 
were sold, given away as party favors, or breakfast cereal bonuses, or you 
name it. So perhaps it is indeed better to be safe about the resolution 
setting and hard-wire it to 320x240.

As to any other kinds of controls on streaming, other than on or off:

insofar as I am aware there are no such controls or setup commands at all 
with these cameras. None. All that I have ever seen one of these to do is 
to start streaming. At most, the chip or firmware ID gets read, nothing 
else.  Thus, there is neither opportunity nor mechanism for instructing 
the camera to do more than start or stop. It is of course logically 
possible that such command sequences may exist in some sort of metaphyical 
reality. But even if they do so exist, I have never those commands put to 
use and so can not know about them. So as far as that kind of thing is 
concerned, it appears to me that there is absolutely nothing left to do 
here.

Theodore Kilgore

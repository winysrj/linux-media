Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56146 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZBFTC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 14:02:26 -0500
Date: Fri, 6 Feb 2009 13:14:19 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>,
	Linux Media <linux-media@vger.kernel.org>,
	Driver Development <sqcam-devel@lists.sourceforge.net>
Subject: Re: [PATCH v3] Add support for sq905 based cameras to gspca
In-Reply-To: <20090206193013.659c6de4@free.fr>
Message-ID: <alpine.LNX.2.00.0902061304000.19328@banach.math.auburn.edu>
References: <200902061804.36756.linux@baker-net.org.uk> <20090206193013.659c6de4@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 6 Feb 2009, Jean-Francois Moine wrote:

> On Fri, 6 Feb 2009 18:04:36 +0000
> Adam Baker <linux@baker-net.org.uk> wrote:
>
>> Add initial support for cameras based on the SQ Technologies SQ-905
>> chipset (USB ID 2770:9120) to V4L2 using the gspca infrastructure.
>> Currently only supports one resolution and doesn't attempt to inform
>> libv4l what image flipping options are needed.
>
> Applied.
>
> As you did not add the supported webcam (Argus Digital Camera DC1512) to
> 	linux/Documentation/video4linux/gspca.txt,
> I had a look at the ms-win driver, and this one also supports the
> webcam 2770:9130 (TCG 501). May I (or you) add it in the sq905's
> device_table?

Jean-Francois,

I am aware that it says this in the inf file for the win driver for these 
cameras, but in all of these years I have never seen any 0x2770:0x9130 
device in the wild. As far as I know there really is no such thing, or 
they put the number in there thinking it was going to be used for some 
chip that never got produced, or something like that. As to the specific 
camera that you mention, the Argus DC-1512, I have owned one of them for 
years, and I have used it as recently as yesterday evening for testing the 
gspca driver. I assure you, it comes up as Product 0x9120 and works just 
fine.

If you want a list of the cameras that I know will work, then a good place 
to start would be the list in libgphoto2/camlibs/sq905/library.c. The 
exception is that a camera which is listed there which has a product 
number 0x913C and I can personaly report that, so far, I have been unable 
to cause it to stream. It might be that, with this timing issue fixed, it 
can now do so. But it is a pretty messed up camera anyway. See the README 
about it.

Understand, too, that there are lots of these cameras out there that I do 
not even know about. The SQ905 for a while was practically *the* chip to 
put in cameras. But AFAIK they are all the same inside, except for minor 
details.


Theodore Kilgore

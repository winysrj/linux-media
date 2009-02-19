Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43907 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZBSSFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 13:05:31 -0500
Date: Thu, 19 Feb 2009 12:17:45 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
In-Reply-To: <20090217200928.1ae74819@free.fr>
Message-ID: <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-2105537084-1235021443=:6388"
Content-ID: <alpine.LNX.2.00.0902190000060.6436@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-2105537084-1235021443=:6388
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0902190000061.6436@banach.math.auburn.edu>



On Tue, 17 Feb 2009, Jean-Francois Moine wrote:

> Hi Kyle,
>
> Looking at the v4l library from Hans de Goede, I did not find the
> decoding of the MR97310A images. May you send him a patch for that?
>
> BTW, I am coding the subdriver of a new webcam, and I could not find
> how to decompress the images. It tried many decompression functions,
> those from the v4l library and most from libgphoto2 without any
> success. Does anyone know how to find the compression algorithm?
>
> Cheers.
>
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/


How ironic that we mention a problem with a webcam's compression and we 
also mention the MR97310 chip. I posted earlier today that I have several 
cameras with MR97310 chip, in addition to the single one which is 
supported by the current module. I mentioned that none of those with ID 
0x093a:0x010e are working, because the image does not come out. Well, 
further investigation reveals that they very likely are using a different 
compression algorithm while running in webcam mode. I modified the code in 
the module to save the SOF marker (which contains the info about which 
compression algorithm is used) and the rest of the header. The rest of the 
header has information in it relating to the image which ought to be kept, 
too.  I also modified the decoding in libv4l to jump past these 12 bytes 
before starting to decode.

What I found:

After shooting a raw frame, I get

FF FF 00 FF 96 64 D0 01 27 00 06 2D

The byte D0 is a new one. I have never seen it before. What I have 
previously seen is written up in camlibs/mars/README.mars. If this byte is 
0, it signifies "no compression." If it is 0x20, the camera is using the 
unknown compression used by only one camera that I have ever seen. If it 
is 0x50 it is the "standard" mr97310 compression which is used in 
camlibs/mars and also here.

My conclusion is that the 0xD0 signifies a new, previously unknown 
compression algorithm. In a way, this is remarkable because the same 
cameras are using the "standard" compression when running in still camera 
mode.

I also looked through my collection of cheap cameras for other 
0x093a:0x010f cameras. I found one that I had missed. It streams. 
Therefore, I would tentatively recommend to add the USB ID 0x093a:0x010f 
to the list of supported cameras in the mr97310a module.

Reasoning for the above:

The two 0x093a:0x010f cameras which do stream also do it perfectly well, 
with not a single problem. The two which do not stream do not stream at 
all. Why does the streaming fail? I don't know right now, but it is clear 
from running in debug mode and from trying to capture one raw image that 
no data comes at all from those two cameras. They go thorough all the 
initial motions just fine, but no data comes out. In any event, one of 
those which do not work is also the one camera discovered years ago 
which also uses still another compression algorithm in stillcam mode and 
is therefore currently useless in stillcam mode, too.

So perhaps it is the right thing to do to include the USB ID 0x093a:0x010f 
but to provide documentation that the streaming works for some of these 
but not all? Is there any policy about things like this?


Theodore Kilgore
---863829203-2105537084-1235021443=:6388--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:41653 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZESSFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 14:05:05 -0400
Date: Tue, 19 May 2009 13:18:53 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: Preliminary results with an SN9C2028 camera
In-Reply-To: <4A12663B.5000001@redhat.com>
Message-ID: <alpine.LNX.2.00.0905191253150.19683@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <200904160014.32558.elyk03@gmail.com> <alpine.LNX.2.00.0905151715210.12530@banach.math.auburn.edu>
 <4A12663B.5000001@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 19 May 2009, Hans de Goede wrote:

>
>
> On 05/16/2009 12:31 AM, Theodore Kilgore wrote:
>> 
>> I decided recently to work on support for the SN9C2028 dual-mode
>> cameras, which are supported as still cameras in
>> libgphoto2/camlibs/sonix. Today, I succeeded in getting three frames out
>> of one of them, using svv -gr, and I was able to convert two of the
>> three frames to nice images using the same decompression algorithm which
>> is used for the cameras in stillcam mode.
>> 
>> There is a lot of work to do yet: support for all appropriate resolution
>> settings (which are what? I do not yet know), support for all known
>> cameras for which I can chase down an owner, and incorporation of the
>> decompression code in libv4l.
>> 
>> However, I thought you might like to know that some success has been
>> achieved.
>> 
>
> Cool!
>
> I recently got a vivitar mini digital camera, usb id 093a 010e,
> CD302N according to gphoto, which also is a dual mode camera. It would
> be nice to get the webcam mode on this one supported too. Do you know
> if there has already been some base work done on that ?


Hans,

Yes, I have been working on that, with some success. Here is an account:

These cameras are MR97310a cameras, specifically the "CIF" variety. They 
will stream at max resolution 352x288, and then at 320x240, 176x144, and 
160x120. I thought at first they are using a different compression 
algorithm from those which are supported currently in gspca/mr97310.c but 
I was mistaken about that. In fact, the compression algorithm is the same 
(so that no code changes in libv4lconvert are required in order to support 
them) but the initialization sequence is quite a bit different.


I succeeded in getting what seemed like a sufficient number of log files 
to be able to put together init sequences which work. I have a preliminary 
version of the code, which works for me with several of the 0x010e cameras 
that I own. Right now, Thomas Kaiser got one of these cameras recently 
(there was some discussion about this a couple of weeks ago, here on the 
list). Someone wrote in to the list and offered one of the cameras for 
testing. I responded and said it should be sent to one of the three people 
who are interested: Kyle Guinn, who wrote the mr97310a.c code, Thomas 
Kaiser, who had some interest in the decompression algorithms, or myself. 
The camera ended up going to Thomas.

About the same time, I sent my code to Thomas. Basically, what I have done 
is to write a replacement for mr97310a.c which supports these cameras in 
addition to the current ones. I hope that we have a report of his testing 
soon. Since you now have one of these cameras, would you like for me to 
send a copy to you, too?

I should mention there are several reasons why I did not feel ready to 
post a formal code patch:

1. The initialization sequences (register writes) seem to be variable from 
one session to another, and they can be influenced on the Windows 
streaming program that I am using, by such things as changing brightness, 
color balance, gamma setting, and so forth, from controls in the Windows 
program. In other words, it is feasible for various controls to talk to 
these cameras (presumably all mr97310a cameras). I was hoping that Thomas 
may know more about such things. Perhaps you do, too?

2. I have one of these "CIF" cameras which will neither stream on Linux 
nor on Windows. It goes throught all of the motions, and a "stream" 
starts. But inspection of the contents of the "stream" shows it consists 
of nothing but sucessive repetitions of the image header. I have tried to 
chase down comments about this camera (Vivitar Mini Digital Camera) 
through Google. It seems that many have had this problem; perhaps some of 
these particular cameras contained buggy hardware.

3. I have another camera (one of the 0x010f "VGA" cameras) which is 
supposed to stream but refuses to supply data across the isoc endpoint. 
Probably this is also a hardware problem. It does not work in Windows, 
either, even though it is supposed to. Perhaps it has merely suffered from 
old age or ill treatment years ago by its owner (me).


So, as I said, I am perfectly willing to send along my code privately, and 
you can have some fun, too, and perhaps you can help me figure out some of 
the remaining issues. This offer, incidentally, is also valid for anyone 
else on this list who has one of these cameras. Just ask.


Theodore Kilgore

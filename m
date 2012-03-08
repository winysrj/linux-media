Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60295 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2CHGG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 01:06:27 -0500
Date: Thu, 8 Mar 2012 00:16:24 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Xavion <xavion.0@gmail.com>
cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux
 anymore
In-Reply-To: <CAKnx8Y7J7PGrw3ekLGhO=uw2mneHEvCzmt4HtArTtk_iJQ3RuQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1203072340320.2356@banach.math.auburn.edu>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com> <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com> <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com> <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com> <4F55DB8B.8050907@redhat.com>
 <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com> <alpine.LNX.2.00.1203061727300.2208@banach.math.auburn.edu> <CAKnx8Y7J7PGrw3ekLGhO=uw2mneHEvCzmt4HtArTtk_iJQ3RuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 8 Mar 2012, Xavion wrote:

> Hi Theodore
> 
> > As to getting that kind of resolution out of a webcam, though, it would be
> > a rather tough go due to the amount of data which has to pass over the
> > wire even if it is compressed data. The frame rate would be pretty
> > atrocious. Therefore, you are probably not going to see that kind
> > of resolution in an inexpensive webcam, at least until USB 3 comes
> > into common use.
> 
> Thanks for offering your thoughts on this matter.  

You are welcome. 

It looks like I'll
> have to keep checking eBay for cheap USB v3 (HD) webcams periodically.

Which somebody will need to support because they will probably not work 
out of the box with an OEM driver CD ;-)

>  For the record, I've only got Motion set to capture four frames per
> second at the moment.
> 
> > Perhaps for now if you want that kind of resolution and do not care about
> > the frame rate very much, you would be better off to buy a slightly
> > fancier camera and do something like using gphoto2 to take timed shots.
> 
> I prefer the idea of captured motion to that of timed snapshots.  The
> captured images and videos are automatically uploaded to my Dropbox
> account.  As I'm only a 'free' user, I must limit the storage space
> that these files consume.
> 

Some of the cheap cameras do work pretty well, actually. But as far as I 
know any resolution better than 640*480 seems to be pretty unusual. Lots 
of "interpolated" higher resolution meaning they have inflated the 
pictures, of course. But some of the 640x480 cameras do better than 
others. And also I should point out that if 4 fps is OK with you then some 
of the cameras do not even do compression. If you could get hold of an old 
SQ905 camera that will do 640x480 it runs on bulk transport and there is 
no compression of frame data at all. Also, what is interesting is that 
with all the cheap cameras they cut corners, of course. But the SQ905 
cameras always seemed to me to tend to have better optics than a lot of 
the other cheap cams. Where they really cut down on features was with the 
controller chip. It will do practically nothing compared to some others. 
The SQ905 used to be advertised as the cheapest camera controller chip on 
the market, once upon a time. But the images one gets from those cameras 
sometimes are not half bad.

Also I should mention that if one wants to get better images out then it 
is best somehow to capture and save the raw data and process it later. 
This is true for any camera which either produces an uncompressed bitmap 
raw image, and also for any camera which does compression of said bitmap 
image before sending it down to the computer. Everything but JPEG, pretty 
much. Why is this? Because the image processing used with webcams must 
necessarily have speed as the number one priority, else the frame rate 
suffers severely. If one is not thus constrained, it is possible to do a 
much better job with that raw data. But remember that you can maximize 
image quality, or you can maximize frame rate. Choose one of the two.

Theodore Kilgore

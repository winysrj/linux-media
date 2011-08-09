Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:51968 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1HITBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 15:01:40 -0400
Date: Tue, 9 Aug 2011 14:06:35 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Adam Baker <linux@baker-net.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <4E40E3A6.2080508@redhat.com>
Message-ID: <alpine.LNX.2.00.1108091259450.23321@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <201108082133.00340.linux@baker-net.org.uk> <alpine.LNX.2.00.1108081543490.21785@banach.math.auburn.edu>
 <4E40E3A6.2080508@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 9 Aug 2011, Hans de Goede wrote:

> Hi,
> 
> <snip>
> 
> > OK, another example. The cameras supported in camlibs/jl2005c do not have
> > webcam ability, but someone could at any time design and market a dualmode
> > which has in stillcam mode the same severe limitation. What limitation?
> > Well, the entire memory of the camera must be dumped, or else the camera
> > jams itself. You can stop dumping in the middle of the operation, but you
> > must continue after that. Suppose that you had ten pictures on the camera
> > and you only wanted to download the first one. Then you can do that and
> > temporarily stop downloading the rest. But while exiting you have to check
> > whether the rest are downloaded or not. And if they are not, then it has
> > to be done, with the data simply thrown in the trash, and then the
> > camera's memory pointer reset before the camera is released. How, one
> > might ask, did anyone produce something so primitive? Well, it is done.
> > Perhaps the money saved thereby was at least in part devoted to producing
> > better optics for the camera. At least, one can hope so. But people did
> > produce those cameras, and people have bought them. But does anyone want
> > to reproduce the code to support this kind of crap in the kernel? And go
> > through all of the hoops required in order to fake the behavior which one
> > woulld "expect" from a "real" still camera? It has already been done in
> > camlibs/jl2005c and isn't that enough?
> 
> This actually is an example where doing a kernel driver would be easier,
> a kernel driver never exits. So it can simply remember where it was
> reading (and cache the data it has read sofar). If an app requests picture
> 10, we read 1-10, cache them and return picture 10 to the app, then the same
> or another app asks for picture 4, get it from cache, asks for picture 20
> read 11-20, etc.

This, in fact, is the way that the OEM software for most of these cheap 
cameras works. The camera is dumped, and then raw files for the pictures 
are created in C:\TEMP. Then the raw files are all processed immediately 
into viewable pictures, after which thumbnails (which did not previously 
exist as separate entities) can be created for use in the GUI app. Then, 
if the user "chooses" to "save" certain of the photos, the "chosen" photos 
are merely copied to a more permanent location. And when the 
camera-accessing app is exited, the temporary files are all deleted.

Clearly, the OEM approach recommends itself for simplicity. Nevertheless, 
there is an obvious disadvantage. Namely, *all* of the raw data from the 
camera needs to be fetched and, as you say, "kept in cache." That "cache" 
is either going to use RAM, or is going to be based in swap. And not every 
piece of hardware is a big, honking system with plenty of gigabytes in the 
RAM slots, and moreover there exist systems with low memory where it is 
also considered not a good idea to use swap. Precisely because of these 
realities, the design of libgphoto2 has consciously rejected the approach 
used in the OEM drivers. Rather, it is a priority to lower the memory 
footprint by dealing with the data piece by piece. This means, 
essentially, handling the photos on the camera one at a time. It is worth 
considering that some of the aforementioned low-powered systems with low 
quantities of RAM on board, and with no allocated swap space are running 
Linux these days.

> 
> Having written code for various small digital picture frames (the keychain
> models) I know where you are coming from. Trust me I do. 

Not to worry. I know where you are coming from, too. Trust me I do. 

Recently I had
> an interesting bug report, with a corrupt PAT (picture allocation table)
> turns out that when deleting a picture through the menu inside the frame
> a different marker gets written to the PAT then when deleting it with the
> windows software, Fun huh?

Yes, of course it is fun. We should not have signed up to do this kind 
of work if we can't take a joke, right? 

But, more seriously, there may be some reason why that different character 
is used -- or OTOH maybe not, and somebody was just being silly. 
Unfortunately, experience tells me it is probably necessary to figure out 
which of the two possibilities it is.

Theodore Kilgore

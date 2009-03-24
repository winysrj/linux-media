Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:50799 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZCXAMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 20:12:00 -0400
Date: Mon, 23 Mar 2009 19:24:50 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: linux-media@vger.kernel.org
Subject: Re: gspca in the LinuxTv wiki
In-Reply-To: <49C80321.60402@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0903231902140.13696@banach.math.auburn.edu>
References: <49C80321.60402@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 23 Mar 2009, Thomas Kaiser wrote:

>
> I was thinking about updating my page [1] with the results I get with gspca 
> V2. But I think it would be better to have this info on the LinuxTV wiki. 
> Unfortunately, I did not find a page for gspca. So I thought I should start 
> one, but I don't think this is the right thing because there are other 
> drivers available for webcams.
>
> Why not start a "Webcam compatibly page" similar to my page [1]?
> - a photo of the webcam
> - USB ID
> - capabilities of the cam
> - the chipsets when known
> - driver + version (+ kernel version), at the time tested
> - application used for testing (version)
> - links with some information to other interesting pages
> - and some more you can think of
>
> What you guys think about it?
>
>
> [1] http://www.kaiser-linux.li/index.php/Linux_and_Webcams
>
> Thomas

Your web page looks nice, as a start. But it is, like most web pages which 
deal with Linux support for category X, Y, or Z of hardware, not up to 
date. Goes with the territory, I guess.

However, I do have one question. How are you going to list the various 
cameras?

Probably, one needs to list them by brand name and model and by USB ID, 
too, as Michel Xaard did with his list in the first place. But then it 
will become a mighty long list. For, the same camera gets recycled in lots 
of different "brands" and "models." This is the kind of information which 
someone needs who is buying a camera, because the camera does not come 
with the USB ID printed on the outside of the package.

But OTOH this causes a problem, too, because the manufacturers of cameras 
(probably some of them are not exactly manufacturers but rather packagers) 
are switching the electronics inside the device any time they feel like 
it, or if they get a large quantity of chips at a good price, or whatever. 
I have seen it happen several times that a certain camera keeps the make 
and model, but it gets a new USB Vendor:Product number. And, worst of all, 
it may have previously been well supported but now it is not. Someone who 
goes and buys the camera based upon the make and model which are 
stencilled on the outside of the camera and printed on the packaging 
material can end up being stung.

Therefore, I would recommend that all possible ways to identify a camera, 
however insignificant those ways might appear to be, should be preserved.

As one example of this kind of information, there is a cheap camera 
distributor in the US called sakar.com. Their cameras always come with a 
little, insignificant number on the outside of the package somewhere. It 
is usually five digits long, and is sometimes found associated with the 
UPC barcode on the package and is found nowhere else. If you want to know 
which camera it is, that number is essential. But it is too typical of all 
of us that we throw away things which appear insignificant. Who would 
think that the bubble-pack card which the camera is packaged in will 
contain information that can be obtained nowhere else, or otherwise only 
by good luck or by trial and error? But, alas, it is true.

Very specific example: The Sakar KidzCam (old version) was an SQ905 
camera and thus well supported. The Sakar KidzCam (new version) is a 
Jeilin JL2005B and uses a particularly nasty compression algorithm which 
has eluded all attempts to figure out. The packaging in the store looks 
identical for both of them. The cameras physically look identical. The 
only way you could tell them apart in the store is by those little bitty, 
insignificant-looking code numbers on the packaging material.

I could give several other examples, too.

Theodore Kilgore

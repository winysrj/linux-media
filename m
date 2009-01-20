Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48480 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbZATKIi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 05:08:38 -0500
Message-ID: <4975A324.7000500@redhat.com>
Date: Tue, 20 Jan 2009 11:10:44 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Olivier Lorin <o.lorin@laposte.net>,
	Adam Baker <linux@baker-net.org.uk>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: RFC: Where to store camera properties (upside down, needs sw
 whitebalance, etc). ?
References: <10881714.65429.1232146611248.JavaMail.www@wwinf8219> <Pine.LNX.4.64.0901171242390.16116@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0901171242390.16116@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Fri, 16 Jan 2009, Olivier Lorin wrote:
> 
> <snip>
> 
> 
>> Post gamma or white balance correction seemed to be more part of the 
>> webcam
>> capabilities than the image state so that the new API to get these 
>> features
>> is quite logical.
> 
> Hmmm.
> 
> While one is in the process of planning ahead, it it good to think of 
> everything. You have not yet seen any code for the sq905c cameras in 
> webcam mode, yet. Well, actually, you can if you want to. The needed 
> sequence of operations is used in the support for
> 
> "gphoto2 --capture-preview"
> 
> in libgphoto2/camlibs/digigr8/library.c.
> 
> What happens with this camera is, the frame data has been compressed and 
> therefore it is needed to know how much data is present for a frame 
> before downloading the rest of the frame. The length of the frame header 
> is set at 0x50 bytes, so one downloads that first. Here is a sample of 
> one such frame header:
> 
> 0000  ff 00 ff 00 ff 00 ff 00-ff 00 ff 00 ff 00 ff 00  ................
> 0010  ff 00 ff 00 ff 00 ff 00-ff 00 ff 00 ff 00 ff 00  ................
> 0020  ff 00 ff 00 ff 00 ff 00-ff 00 ff 00 ff 00 ff 00  ................
> 0030  ff 00 ff 00 ff 00 ff 00-ff 00 ff 00 ff 00 ff 00  ................
> 0040  e0 5a 00 00 3b 3e 50 3b-36 00 ff 00 ff 00 ff 00  .Z..;>P;6.......
> 
> Now, most of this is just filler. The data size for the frame is to be 
> found in bytes 0x40 and 0x41 and it says that 0x5ae0 bytes must be 
> downloaded for this frame. I have never seen the next two bytes with 
> anything in them, so my reasonable conjecture is that they are similarly 
> used, as part of the data size field. It is just that in practice one 
> never sees a frame with so much data in it.
> 
> Now, my comment here is directed toward bytes 0x44 through 0x48. I do 
> not claim to know exactly what they mean. However, I would strongly 
> suspect that they have something to do with contrast, color balance, 
> intensity, and so on. Really, logic would seem to indicate that there is 
> no other point to providing those entries, which certainly do vary from 
> one frame to another and the readings in them do seem in some vague 
> sense to have something to do with the local light conditions, and sucn.
> 
> Therefore, confronted with my experience with these cameras, I would 
> tend to suspect that
> 
> "Post gamma or white balance correction seemed to be more part of the 
> webcam capabilities than the image state"
> 
> may not always be the case. For, here, with this camera, it appears that 
> some kind of related information is being passed with each individual 
> frame.

Yes, we've seen that more often. In this case the solution is simple, since we 
need to do decompression in userspace anyways, just pass the entire frame 
including the header (with the potential interesting bytes) to userspace in the 
frame buffer, then userspace can get that info if it needs to.

A bigger problem is when this happens and the cam generates a standard format 
like jpeg (with an additional header), but we haven't encountered cams like 
this yet, so lets not worry about that for now.

Regards,

Hans
'

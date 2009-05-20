Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43119 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZETTjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 15:39:39 -0400
Date: Wed, 20 May 2009 14:53:31 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Subject: Re: What is libv4lconvert/sn9c202x.c for?
In-Reply-To: <4A144E41.6080806@redhat.com>
Message-ID: <alpine.LNX.2.00.0905201449220.21017@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu> <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu> <4A144E41.6080806@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 20 May 2009, Hans de Goede wrote:

>
>
> On 05/19/2009 10:35 PM, Theodore Kilgore wrote:
>> 
>> I can not seem to be able to find any such devices which use this. So
>> perhaps I am not looking in the right place and someone could point me
>> there.
>> 
>> In any event, it appears to me to have absolutely nothing at all to do
>> with the decompression algorithm required by the SN9C2028 cameras. Those
>> require a differential Huffman encoding scheme similar to what is in use
>> for the MR97310a cameras, but with a few crucial differencew which make
>> it pretty much impossible to write one routine for both. But the code in
>> the file libv4lconvert/sn9c202x.c appears to me to be no differential
>> Huffman scheme at all but something entirely different.
>> 
>> Hence my question.
>
> This is for the (not yet in the mainline kernel) sn9c20x driver, just like
> there is a series of sn9c10x webcam bridges from sonix there also is a serie
> of 2n9c20x, these can do jpeg compression, but also their own custom
> (less CPU the decompress) YUV based compression, which is supported by 
> libv4l,
> and that is what is in the sn9c20x.c file, also note the file is called
> sn9c20x.c not sn9c202x.c, iow this is completely unrelated to the sn9c2028
> cameras, as this is not for sn9c202x but for sn9c20x .
>
> Hope this helps to clarify things.
>
> Regards,
>
> Hans
>
>
> p.s.
>
> The sn9c20x driver can be found here:
> https://groups.google.com/group/microdia
>
> Its developers are quite active I wish they would get it merged into the
> mainline (and preferably first converted to a gspca subdriver, I'm not saying
> gspca is perfect, but it does safe a lot of code duplication).
>

Yes, that does help. I called the new libv4lconvert file by the name 
sn9c2028-decomp.c and that should avoid any possible name collision. But 
it was indeed rather strange to see that the sn9c20x is in libv4lconvert 
and it seems not to be in the drivers/media tree anywhere. Thanks again 
for explaining.

Theodore Kilgore

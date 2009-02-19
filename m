Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55962 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZBSA2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 19:28:13 -0500
Date: Wed, 18 Feb 2009 18:40:21 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
In-Reply-To: <200902171907.40054.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0902181825210.6128@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 17 Feb 2009, Kyle Guinn wrote:

> On Tuesday 17 February 2009 13:09:28 Jean-Francois Moine wrote:
>> Hi Kyle,
>>
>> Looking at the v4l library from Hans de Goede, I did not find the
>> decoding of the MR97310A images. May you send him a patch for that?
>>
>
> Yes, I sent this to him some time ago.  Take a look here:
> http://linuxtv.org/hg/~hgoede/v4l-dvb/rev/a647c2dfa989
>
> -Kyle
> --

I have several cameras with this chipset in them; they are supported in 
libgphoto2 under camlibs/mars. Therefore, I was very interested when I 
found this driver, which was based upon the old Aiptek Pencam VGA+ 
0x08ca:0x0111. I can confirm that my Aiptek Pencam VGA+ also works. I also 
tried out some other cameras, thinking that their USB Vendor:Product IDs 
should be added. I met only mixed success with them.

1. 0x093a:0x010f cameras: I own three of them. Only one of the three will 
stream. The other two will not. The streaming fails at a very early stage, 
due to a USB error. Since one of them does work, should this ID be added? 
Pro: It works quite nicely. Con: The other cameras with the same USB 
Vendor:Product number do not work at all.

2. 0x93a:0x010e cameras: All of them will emit some kind of stream, but 
the output is not viewable, coming up instead as nonsense. I am somewhat 
nonplussed by this, in view of the fact that all of these cameras but one
use the same decompression algorithm as the Aiptek. The one which uses a 
different decompression algorithm is not supported in libgphoto2, either. 
It is one of the 0x093a:0x010f cameras.

Theodore Kilgore

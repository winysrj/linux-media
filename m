Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60076 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128AbZCPSII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:08:08 -0400
Date: Mon, 16 Mar 2009 13:20:44 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC][PATCH 0/2] Sensor orientation reporting
In-Reply-To: <49BE0709.9060300@hhs.nl>
Message-ID: <alpine.LNX.2.00.0903161317180.4682@banach.math.auburn.edu>
References: <200903152224.29388.linux@baker-net.org.uk> <49BE0709.9060300@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 16 Mar 2009, Hans de Goede wrote:

> Adam Baker wrote:
>> Hi all,
>> 
>> I've finally got round to writing a sample patch to support the proposed 
>> mechanism of reporting sensor orientation to user space. It is split into 2 
>> parts, part 1 contains the kernel changes and part 2 the libv4l changes. In 
>> order to keep the patch simple I haven't attempted to add support to libv4l 
>> for HFLIP and VFLIP but just assumed for now that if a cam needs one then 
>> it needs both. If the basic idea gets accepted then fixing that is purely a 
>> user space change.
>> 
>> I also haven't provided an implementation of VIDIOC_ENUMINPUT in libv4l 
>> that updates the flags to reflect what libv4l has done to the image. Hans 
>> Verkuil originally said he wanted to leave the orientation information 
>> available to the user app but I suspect that is actually undesirable. If an 
>> app is designed to work without libv4l and to re-orient an image as 
>> required then if someone runs it with the LD_PRELOAD capability of libv4l 
>> then correct operation depends upon reporting the corrected orientation to 
>> the app, not the original orientation.
>>

Finally, we can get the SQ905 cameras to work right-side-up, and move on 
to other things. This appears to me to be exactly the kind of solution 
which we needed.

Theodore Kilgore

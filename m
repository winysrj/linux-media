Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:56975
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZJCDXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 23:23:46 -0400
Cc: Bill Davidsen <davidsen@tmr.com>,
	video4linux M/L <video4linux-list@redhat.com>,
	Andy Walls <awalls@radix.net>
Message-Id: <F05EB5AC-F40E-4FD6-92D6-5DB92406A4C8@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: LMML <linux-media@vger.kernel.org>
In-Reply-To: <1254514454.3169.51.camel@palomino.walls.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Upgrading from FC4 to current Linux
Date: Fri, 2 Oct 2009 23:24:13 -0400
References: <4AC5FA6E.2000201@tmr.com> <1254514454.3169.51.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 2, 2009, at 4:14 PM, Andy Walls wrote:

>> Video used to be easy, plug in the capture device, install xawtv  
>> via rpm, and
>> use. However, recent versions of Fedora simply don't work, even on  
>> the same
>> hardware, due to /dev/dsp no longer being created and the  
>> applications like
>> xawtv or tvtime still looking for it.
>
> (Non-emulated) OSS was ditched by the linux kernel folks long ago.   
> And
> I thought xawtv and tvtime were abandon-ware.

Yeah, seems that way. Though Devin's been talking about maybe starting  
up a new tvtime maintenance tree, which Fedora would be happy to  
contribute to and track... (nudge, nudge, Devin ;)

>> The people who will be using this are looking for hardware which is  
>> still made
>> and sold new, and software which can be installed by a support  
>> person who can
>> plug in cards (PCI preferred) or USB devices, and install rpms.
>
> rpmfusion, ATrpms, and I even think Fedora have MythTV available now.
> mplayer is probably also available from 2 of those 3 resources.

MythTV and mplayer are both only in RPM Fusion and ATrpms. Both rely  
on ffmpeg, which is no-go for Fedora itself.

> For any open source software that implements video and audio decoders,
> you will need to investigate if you must pay someone licensing fees to
> use the decoders you need to meet your usage requirements.  Fedora  
> has a
> mechanism in place by which you can pay for the non-free codecs, IIRC.

Sort of. If you're using something gstreamer-based (like totem).  
Fedora used to have codeina (formerly codec-buddy) that would point  
you at Fluendo's site for some gstreamer codec plugins you  could buy.  
The current world order is PackageKit with a codec plugin that tries  
to find a plugin that provides the codec in your configured yum repos.  
Can't recall if it points at Fluendo if nothing is found...


-- 
Jarod Wilson
jarod@wilsonet.com





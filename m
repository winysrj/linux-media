Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:39820 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab0DFQQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 12:16:51 -0400
Message-ID: <4BBB5F12.5040102@cam.ac.uk>
Date: Tue, 06 Apr 2010 17:19:30 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
References: <201004052347.10845.hverkuil@xs4all.nl> <201004060012.48261.hverkuil@xs4all.nl> <alpine.DEB.1.10.1004060933550.27169@cnc.isely.net>
In-Reply-To: <alpine.DEB.1.10.1004060933550.27169@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/10 15:41, Mike Isely wrote:
> On Tue, 6 Apr 2010, Hans Verkuil wrote:
> 
>    [...]
> 
>>
>> One thing that might be useful is to prefix the name with the control class
>> name. E.g. hue becomes user_hue and audio_crc becomes mpeg_audio_crc. It would
>> groups them better. Or one could make a controls/user and controls/mpeg
>> directory. That might not be such a bad idea actually.
> 
> I agree with grouping in concept, and using subdirectories is not a bad 
> thing.  Probably however you'd want to ensure that in the end all the 
> controls end up logically at the same depth in the tree.
> 
> 
>    [...]
> 
>>
>> An in between solution would be to add _type files. So you would have 
>> 'hue' and 'hue_type'. 'cat hue_type' would give something like:
>>
>> int 0 255 1 128 0x0000 Hue
>>
>> In other words 'type min max step flags name'.
> 
> There was I thought at some point in the past a kernel policy that sysfs 
> controls were supposed to limit themselves to one value per node.
It's usually considered to be one 'conceptual' value per node, though
this falls fowl of that rule too.  So you could have one file with a list
of possible values, or even one for say hue_range 0...255 but people are
going to through a wobbly about antyhing with as much data in it as above.

The debate on this was actually pretty well covered in an lwn article the
other week. http://lwn.net/Articles/378884/

So the above hue type would probably need:

hue_type (int)
hue_range (0...255)
hue_step (1)
hue_flags (128)
hue_name (Hue)

Of those, hue_name doesn't in this case tell us anything and hue_step could
be suppressed as an obvious default.  It could be argued that parts of the
above could be considered a single 'conceptual' value but I don't think the
whole can be.  The reasoning behind this  (and it is definitely true with
your above example) is that sysfs should be human readable without needing
to reach for the documentation.
> 
>>
>> And for menu controls like stream_type (hmm, that would become 
>> stream_type_type...) you would get:
>>
>> menu 0 5 1 0 Stream Type

>> MPEG-2 Program Stream
>>
>> MPEG-1 System Stream
>> MPEG-2 DVD-compatible Stream
>> MPEG-1 VCD-compatible Stream
>> MPEG-2 SVCD-compatible Stream
>>
>> Note the empty line to denote the unsupported menu item (transport stream).
>>
>> This would give the same information with just a single extra file. Still not
>> sure whether it is worth it though.
> 
> Just remember that the more complex / subtle you make the node contents, 
> then the more parsing will be required for any program that tries to use 
> it.  I also think it's probably a bad idea for example to define a 
> format where the whitespace conveys additional information.  The case 
> where I've seen whitespace as part of the syntax actually work cleanly 
> is in Python.
> 
> 


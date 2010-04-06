Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:40956 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFOlO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 10:41:14 -0400
Date: Tue, 6 Apr 2010 09:41:13 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: RFC: exposing controls in sysfs
In-Reply-To: <201004060012.48261.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.1.10.1004060933550.27169@cnc.isely.net>
References: <201004052347.10845.hverkuil@xs4all.nl> <201004060012.48261.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Apr 2010, Hans Verkuil wrote:

   [...]

> 
> One thing that might be useful is to prefix the name with the control class
> name. E.g. hue becomes user_hue and audio_crc becomes mpeg_audio_crc. It would
> groups them better. Or one could make a controls/user and controls/mpeg
> directory. That might not be such a bad idea actually.

I agree with grouping in concept, and using subdirectories is not a bad 
thing.  Probably however you'd want to ensure that in the end all the 
controls end up logically at the same depth in the tree.


   [...]

> 
> An in between solution would be to add _type files. So you would have 
> 'hue' and 'hue_type'. 'cat hue_type' would give something like:
> 
> int 0 255 1 128 0x0000 Hue
> 
> In other words 'type min max step flags name'.

There was I thought at some point in the past a kernel policy that sysfs 
controls were supposed to limit themselves to one value per node.

> 
> And for menu controls like stream_type (hmm, that would become 
> stream_type_type...) you would get:
> 
> menu 0 5 1 0 Stream Type
> MPEG-2 Program Stream
> 
> MPEG-1 System Stream
> MPEG-2 DVD-compatible Stream
> MPEG-1 VCD-compatible Stream
> MPEG-2 SVCD-compatible Stream
> 
> Note the empty line to denote the unsupported menu item (transport stream).
> 
> This would give the same information with just a single extra file. Still not
> sure whether it is worth it though.

Just remember that the more complex / subtle you make the node contents, 
then the more parsing will be required for any program that tries to use 
it.  I also think it's probably a bad idea for example to define a 
format where the whitespace conveys additional information.  The case 
where I've seen whitespace as part of the syntax actually work cleanly 
is in Python.


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

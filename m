Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m93C6Z6L005953
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 08:06:36 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m93C5WVt026541
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 08:05:33 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810031313.36607.hverkuil@xs4all.nl>
References: <200810031313.36607.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 08:07:06 -0400
Message-Id: <1223035626.3121.38.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: move zoran/core/i2c drivers to separate directories
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 2008-10-03 at 13:13 +0200, Hans Verkuil wrote:
> Hi all,
> 
> It looks like 2.6.27 is nearing completion, so this is a good time to 
> reorganize the video tree. IMHO it's getting rather messy in the 
> media/video directory and I propose to make the following changes:
> 
> 1) the zoran driver sources are moved into a video/zoran directory.
> 2) the v4l core sources (v4l* and videobuf*) are moved into a video/core 
> directory. Since I'll be adding more v4l core sources in the near 
> future this would keep everything together nicely.

> 3) the i2c drivers are moved to either media/video/i2c or media/i2c (I 
> have no preference). This should make it easier to see what is the 
> actual v4l driver and what is a supporting i2c driver. It's rather 
> mixed up right now.

If the i2c drivers can be shared with Digital Video cards, then
media/video/i2c probably isn't the best.  media/i2c or media/common/i2c
might be better.

<thinking out loud>

Would there be something more descriptive than "i2c"? That describes the
bus to which the support chips connect, but lumps together audio
multiplexers, eeproms, analog broadcast decoders, etc., right?

Classification by bus interface doesn't seem to have a strong precedent.
The rest of the kernel generally doesn't appear to lump every device
with a common interface under a directory, but instead devices with
common functions (drivers/scsi, drivers/video, drivers/net).  I should
note though that the drivers/char directory has survived with a big pile
of "stuff" for quite some time.

How about media/video/ancillary or media/common/ancillary to cover
ancillary support chips and functions that are otherwise unclassified in
the directory structure/taxonomy?

</thinking out loud>

To bring it up a level, you have identified a requirement to simplify
something and have an implicit measure of complexity (logically
unrelated files in the host driver directory?) that you'd like to
reduce.  So what does it take to meet that requirement without
increasing some other undesirable measure: the count of directories
under linux/drivers/media or how many files do my "grep -R" searches
have to wade through now? :)




> There are probably some sources where it is not clear where they should 
> go (e.g. ir-kbd-i2c.c), when in doubt I prefer to keep them where they 
> are now, they can always be moved later.

"ancillary", or something similar, covers ancillary support chips and
functions like ir-kdb-i2c.c and tveeprom.c.

But it's all semantics I suppose.

Regards,
Andy

> Are there any objections? Suggestions?
> 
> Regards,
> 
> 	Hans
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3UBn1pw000751
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 07:49:01 -0400
Received: from portal.bppiac.hu (portal.bppiac.hu [213.253.216.130])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3UBmk0Q017373
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 07:48:47 -0400
Message-ID: <48185C99.807@bppiac.hu>
Date: Wed, 30 Apr 2008 13:48:41 +0200
From: Farkas Levente <lfarkas@bppiac.hu>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [Fwd: [gst-devel] RFC: multi channel frame grabber card support]
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

hi,
a few weeks ago i send this mail to gstreamer-devel but it seems nobody 
reply to it. i'd like to know the v4l people's opinion's about it. or 
may be we've to modify the v4l or v4l2 interface in the bellow case to 
give us more device?
i'd like to know your opinion.
thanks in advance.
yours.

-------- Original Message --------
Subject: [gst-devel] RFC: multi channel frame grabber card support
Date: Fri, 11 Apr 2008 14:51:23 +0200
From: Farkas Levente <lfarkas@bppiac.hu>
To: Gstreamer <gstreamer-devel@lists.sourceforge.net>

hi,
as i wrote earlier we'd like to add support for multi channel frame
grabber cards in gstreamer. what's the problem:
currently there are the only hardware video input supported by gstreamer
is the v4l or v4l2 compatible video sources. there are good for common
hardware like ip camera, tv card (with tunner) or other hardware like
s-video input etc. but there are many kind of card which has more
(4,8,16,24) input channel (usually analog input). there card can give
raw or encoded video sources. but these usually has one physical devices
ie. one /dev/videoX devices (in this case we've got n composite input).
we'd like to build in this case n pipeline for the n input channel. one
of the simple example IVC-100 card which has one bt878 chip and 4
composite input and one 4 channel multiplexer.
http://www.iei.com.tw/en/product_IPC.asp?model=IVC-100G
in this case we can use v4l and choose one of the channel but we'd like
to build 4 pipeline and set different parameters on the different
pipeline's source properties (like frame rate, resolution etc). what's
more we'd like to modify the source element properties during it's
running eg. i'd like to modify the 2nd channel frame rate while wouldn't
like to stop the other 4 pipeline!!! and it's an important feature.
what we can do?
- we can create a new source element with 4 output pads,
- or create a new source element with one output pad, but we'd like to
create 4 such source element which can parallel use the same device's
different input channel.
the first would be the easier, but in this case we can't modify one of
the input channel's parameter without stop the other pipelines:-( or can
i do it somehow? and in this case all of the pipeline has to be run in
the same process.
in the second case we can start and stop the pipeline independently
what's more use them in different process, but we probably have to
create some kind of master/controller process which control the access
of the source elements to the device.
what do you think about it?
what do you suggest about it?
what's your comments?
thanks in advance.
yours.

-- 
    Levente                               "Si vis pacem para bellum!"

-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference
Don't miss this year's exciting event. There's still time to save $100.
Use priority code J8TL2D2.
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
_______________________________________________
gstreamer-devel mailing list
gstreamer-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/gstreamer-devel

-- 
   Levente                               "Si vis pacem para bellum!"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

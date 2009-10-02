Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n92CkGhv028758
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 08:46:16 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92Ck4Wo028939
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 08:46:06 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n92Ck3EE023973
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 08:46:03 -0400
Message-ID: <4AC5F60B.7040804@tmr.com>
Date: Fri, 02 Oct 2009 08:46:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <1253120892.3669.11.camel@paulo-desktop>
In-Reply-To: <1253120892.3669.11.camel@paulo-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Create a /dev/video0 file and write directly into it images
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

Paulo Freitas wrote:
> Hi everyone,
> 
> I have an Ethernet Camera, from Prosilica, and I need to somehow emulate
> this camera in a /dev/video0 file. My idea is, mount a driver file using
> 'makedev', pick up images from the camera and write them into
> the /dev/video0 file. You know how V4L can be used to write images
> in /dev/video files? I don't know if it is needed to use makedev
> probably not. Any suggestion is welcome.
> 
I'm not sure I see what the end use is here, watching or recording, but you 
might be able to use existing software which can generate streaming video and 
then use tools which can accept that over a network (could just be loopback if 
that fits your use).

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

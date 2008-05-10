Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4A0Fb76008569
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 20:15:37 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4A0FPDF007814
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 20:15:25 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@gmail.com>
In-Reply-To: <e686f5060805091255m70e5d959i1ee3169232aadda2@mail.gmail.com>
References: <e686f5060805091255m70e5d959i1ee3169232aadda2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 20:14:36 -0400
Message-Id: <1210378476.3292.52.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Is anyone else running a CX18 in 64bit OS?
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

On Fri, 2008-05-09 at 15:55 -0400, Brandon Jenkins wrote:

Brandon,

Yes I'm running the cx18 driver with an HVR-1600 on a 64 bit OS.

> I have noticed an appreciable difference in video capture quality.

The first analog capture after a modprobe of the cx18 is usually
terrible and unwatchable due to apparently lost frames or no initial
audio followed by audio and lost frames.  The work around is to stop the
analog capture and restart.

Would you characterize the analog capture quality problems as being only
on weak channels or strong channels as well?

>  The
> timeline for the change is exactly the same time that development
> ceased on the IVTV version of CX18 and moved to V4L.

I'm not clear on exactly what versions you mean.  Do you have hg
repository names and change ID's?


>  I see heavy
> pixelation in analog capture and the dvb tuner module returns far
> fewer channels on a scan than before. I would like to troubleshoot,
> please let me know what is needed.


Since you have the two particular source trees at hand, could you do a
recursive diff so we can see the changes?  That hopefully will narrow
the search for potential causes.

Regards,
Andy

> I am attaching dmesg/channel.conf/channel scan output for v4l drivers
> comparing the results from a cx18 and a cx23885 card. (hvr-1600 and
> hvr-1800) If I switch back to the older ivtv and mxl500s dvb tuner all
> works fine.
> 
> Thanks in advance
> 
> Brandon


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

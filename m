Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBT0c9Vx029931
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 19:38:09 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBT0buaD004630
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 19:37:56 -0500
Received: by wf-out-1314.google.com with SMTP id 25so4464987wfc.6
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 16:37:55 -0800 (PST)
Message-ID: <199bcede0812281637se69e759m2bc750f0cc84b6ca@mail.gmail.com>
Date: Sun, 28 Dec 2008 18:37:55 -0600
From: "David Lonie" <loniedavid@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: KWorld ATSC-115 strange problems
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

I recently started setting up a KWorld PlusTV ATSC-115 to work
alongside my PVR-150 in a mythtv box.

For the first few attempts at using it I got black screens in xawtv
and myth. I followed the mythtv wiki, asked around on IRC and got
nothing.

Eventually (I have no idea what changed...) I got a picture! No sound,
but I could see all the channel's from my analog cable signal in both
myth and xawtv. I rebooted to see if this would work by default, and
when I did I got static. I switched the cable from the top to the
bottom connector and the picture came back (!). I have no clue why the
card spontaneously changed inputs like that...

Problem is, there's still no sound and I can't change channels. I'm
stuck listening to some big-haired bimbo go on and on about who the
sexiest tv doctor is on the charter channel.

I fooled around a bit, trying the v4l hg drivers, the 2.6.27 drivers,
etc, but no luck. I've reconfigured the card in myth a dozen times,
unloaded and reloaded the module, etc. Any ideas what I should try
next? Any output that may be useful to anyone? I've run out of ideas
myself.

Dave

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

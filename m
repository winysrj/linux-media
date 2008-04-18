Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IGREKD004521
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 12:27:14 -0400
Received: from imo-m23.mx.aol.com (imo-m23.mx.aol.com [64.12.137.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3IGR2uj032715
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 12:27:02 -0400
Received: from JonLowe@aol.com
	by imo-m23.mx.aol.com (mail_out_v38_r9.3.) id e.d4c.1a78ea7c (37047)
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 12:26:54 -0400 (EDT)
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Apr 2008 12:26:54 -0400
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <8CA6F8825F2FE35-FC8-9F4@FWM-D12.sysops.aol.com>
Subject: HVR-1500 issues
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

I'm running Ubuntu 8.04 with the 2.6.24-16 generic kernel on a laptop, 
and want to use a Hauppauge HVR-1500 Expresscard. I've followed the 
procedure on the V4LWiki to build the drivers.  However, it builds them 
to the 2.6.24-15 kernel instead of the -16 kernel.  How do I force it 
to build to the currently used kernel?  I've confirmed that it is still 
using the old driver in the -16 kernel.  If I start with the -15 
kernel, it sees the card.

I was forced to update the sources in v4l-dvb since that directory 
already existed; it wouldn't let me overwrite it.  Is it safe to delete 
that directory altogether so I can get a fresh download from mercurial?

Now if I run ubuntu with the -15 kernel, it sees the card.  ME TV is 
the only app that seems to want to scan for channels.  Kaffeine sees 
the card, but won't scan.  ME TV scans, but then complains that 
channels.conf has an invalid entry.  Has anyone actually gotten an 
HVR-1500 to work under Ubuntu?  if so, can you give step by step, as I 
am a newbie?

Thanks!


Jon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

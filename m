Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK1EVJS022553
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 20:14:31 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBK1ECmv000558
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 20:14:12 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1LDqQ3-0002lb-Jn
	for video4linux-list@redhat.com; Sat, 20 Dec 2008 02:14:15 +0100
Date: Sat, 20 Dec 2008 02:14:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0812171921420.8733@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812200104090.9649@axis700.grange>
References: <1228166159-18164-1-git-send-email-robert.jarzmik@free.fr>
	<87iqpi4qb0.fsf@free.fr>
	<Pine.LNX.4.64.0812171921420.8733@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: soc-camera: current stack
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

I uploaded an updated version of the soc-camera patch stack at

http://gross-embedded.homelinux.org/~lyakh/v4l-20081219/

This should produce an equivalent of what is currently in my hg tree - at 
least in what soc-camera concerns. If there's any interest, I might look 
into installing a git-server and providing a git-tree with soc-camera 
patches on that server, for 3 users to pull 5 putches every 2 weeks my 
400MHz ARM9 on a dyndns ADSL line should be enough:-)

Next on queue (not yet in any of the directories on that server)

mt9t031
tw9910
i.MX31
prepare pxa, sh, and all cameras to handle extra SOCAM_ flags being 
	checked in soc_camera_bus_param_compatible()
check extra SOCAM_ flags in soc_camera_bus_param_compatible()

we'll try to do the latter two slowly and carefully...

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

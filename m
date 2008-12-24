Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOHYksj020658
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:34:46 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBOHYUCD002347
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:34:30 -0500
Date: Wed, 24 Dec 2008 18:34:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87wsdplc29.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0812241831210.5463@axis700.grange>
References: <1228166159-18164-1-git-send-email-robert.jarzmik@free.fr>
	<87iqpi4qb0.fsf@free.fr>
	<Pine.LNX.4.64.0812171921420.8733@axis700.grange>
	<Pine.LNX.4.64.0812200104090.9649@axis700.grange>
	<87wsdplc29.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
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

On Wed, 24 Dec 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > This should produce an equivalent of what is currently in my hg tree - at 
> > least in what soc-camera concerns. If there's any interest, I might look 
> > into installing a git-server and providing a git-tree with soc-camera 
> > patches on that server, for 3 users to pull 5 putches every 2 weeks my 
> > 400MHz ARM9 on a dyndns ADSL line should be enough:-)
> >
> > Next on queue (not yet in any of the directories on that server)
> 
> Hi Guennadi,
> 
> I made some tests of your patches against mainline tree (2.6.28-rc4 actually),
> on pxa271 + mt9m111.
> 
> I have one little problem I can't remember having before :
> 
> [  728.372987] Backtrace:
> [  728.378014] [<bf05f230>] (mt9m111_set_register+0x0/0x80 [mt9m111]) from [<bf056300>] (soc_camera_s_register+0x2c/0x38 [soc_camera])
> [  728.388248]  r5:039e6cf0 r4:00000018
> [  728.393278] [<bf0562d4>] (soc_camera_s_register+0x0/0x38 [soc_camera]) from [<c0164734>] (__video_ioctl2+0x684/0x39a4)
> [  728.403419] [<c01640b0>] (__video_ioctl2+0x0/0x39a4) from [<c0167a70>] (video_ioctl2+0x1c/0x20)
> [  728.413404] [<c0167a54>] (video_ioctl2+0x0/0x20) from [<c009a8fc>] (vfs_ioctl+0x74/0x78)
> [  728.423393] [<c009a888>] (vfs_ioctl+0x0/0x78) from [<c009acb8>] (do_vfs_ioctl+0x390/0x4ac)
> [  728.433342]  r5:039e6cf0 r4:c39d3340
> [  728.438221] [<c009a928>] (do_vfs_ioctl+0x0/0x4ac) from [<c009ae14>] (sys_ioctl+0x40/0x68)
> [  728.447976] [<c009add4>] (sys_ioctl+0x0/0x68) from [<c0024e80>] (ret_fast_syscall+0x0/0x2c)
> [  728.457785]  r7:00000036 r6:4018564f r5:039e6cf0 r4:00000000
> [  728.462692] Code: e89da800 e1a0c00d e92dd830 e24cb004 (e5913000)
> [  728.468135] ---[ end trace a231255d0862dac6 ]---

You didn't post the top part - from ---[ start trace ... ]--- (or whatever 
it is marked), it shows the exact PC and the reason for the Oops. But it's 
strange - I don't think anything has changed aroung controls / 
get/set_register. Have you replaced both the kernel and the modules? 
Sorry, stupid question, but it really looks strange.

> I'm not sure whether the problem is not on my setup, I hadn't touched it for
> days. I know after opening the video device, I setup a camera register before
> taking the picture (to set up the test pattern and automate my non-regression
> tests).
> 
> Will check after Christmas :)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

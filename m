Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1FF9Fi031958
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 10:15:09 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1FE9LZ001622
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 10:14:10 -0500
Date: Mon, 1 Dec 2008 16:14:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <873ah8n8d3.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0812011612000.3915@axis700.grange>
References: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
	<Pine.LNX.4.64.0811290229070.7032@axis700.grange>
	<873ah8n8d3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: About CITOR register value for pxa_camera
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

On Sun, 30 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > I finally got round to trying this...
> >
> > Please, have a look at this patch. I decided against another function call 
> > for a number of reasons: first, if the host calls into the camera to ask 
> > whether the frequency has changed, it is not easy to recognise, whether it 
> > changed _now_, if you let camera notify the host about frequency change 
> > this breaks the hierarchy. Second, you don't know how many more similar 
> > parameters will have to be communicated between the camera and the host. 
> > So, I decided to add an extensible sense struct.
> >
> > Only compile tested so far, will run-test later, maybe tomorrow (actually, 
> > already today). Comments welcome, tests even more so:-)
> The first test crashes in the pxa_camera_probe() for me, something like :
> [  247.554669] [<c014f2f8>] (dev_driver_string+0x0/0x48) from [<bf01eac8>] (pxa_camera_probe+0x2c8/0x424 [pxa_camera])
> [  247.564907] [<bf01e800>] (pxa_camera_probe+0x0/0x424 [pxa_camera]) from [<c01538fc>] (platform_drv_probe+0x20/0x24)
> [  247.575129] [<c01538dc>] (platform_drv_probe+0x0/0x24) from [<c0152a3c>] (driver_probe_device+0xac/0x1b0)
> [  247.585308] [<c0152990>] (driver_probe_device+0x0/0x1b0) from [<c0152bd0>] (__driver_attach+0x90/0x94)
> 
> I'll take some time tomorrow, to review and test.
> 
> > Patch below. Loosely based on top of our current format-negotiation 
> > stack...
> Applies nicely, thanks.

As you might have seen, I posted two patches on the list earlier today 
(with you on cc), which fix this Oops and one more bug in a formula. If 
the patches look fine to you or better yet, if you can test them and they 
pass your test, I'll push them upstream with a next request.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

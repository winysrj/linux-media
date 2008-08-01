Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71LR1lx018398
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 17:27:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m71LQlL3030717
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 17:26:47 -0400
Date: Fri, 1 Aug 2008 23:26:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87ljzgfo4s.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0808012305080.14927@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr> <87y73h204v.fsf@free.fr>
	<Pine.LNX.4.64.0808012135300.14927@axis700.grange>
	<87ljzgfo4s.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

On Fri, 1 Aug 2008, Robert Jarzmik wrote:

> Ah, I didn't thought of soc_camera_host_ops ... But I agree, it may be better to
> call soc_camera_host_ops->suspend() rather than pxa-camera::suspend(). Which
> brings me to another question, in which order :
>  a) soc_camera_ops->suspend() then soc_camera_hosts->suspend()
>  b) soc_camera_hosts->suspend() then soc_camera_ops->suspend()
> 
> For me, the only working order can be (a), because I need
> soc_camera_host->resume() first to enable QIF Clock, so that i2c interface is
> usable on Micron chip, so that soc_camera->resume() can send i2c commands to the
> camera. Do you think the same ?

On resume we have to do this exactly as you have done it in your last 
patch: first restore general parameters on the host, then resume the 
camera, and then continue with the FIFOs and activating the DMA. So, I 
think, we have no choice but to only call host's resume, passing it the 
camera device as a parameter, and let it decide when it wants to resume 
the camera. Similar on suspend. This will also be consistent with how 
pxa_camera_add_device() calls icd->ops->init(icd) and 
pxa_camera_remove_device() calls icd->ops->release(icd).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

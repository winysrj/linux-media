Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72AM3w3008549
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 06:22:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72ALkXS012674
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 06:21:47 -0400
Date: Sat, 2 Aug 2008 12:21:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87od4b69ug.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0808021218280.24786@axis700.grange>
References: <87tze4cr3g.fsf@free.fr>
	<1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
	<1217629566-26637-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0808020128060.14927@axis700.grange>
	<87od4b69ug.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
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

On Sat, 2 Aug 2008, Robert Jarzmik wrote:

> To be exact: wrong copy/paste. I'm sorry not have spotted this, I have no
> suspend function in mt9m111, I only used the resume one to restore the state ...
> 
> And the two lines should be :
> +	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
> +		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
>                                                            ^
>                                                            compile error without
> 
> Apart from that, I tested, and it's OK.

Right:-) Hope, we get it right this time. A pull request just went out to 
the v4l-dvb-maintainer list.

> Do you have an exported git tree I can sync with ?

No, sorry, just a mercurial tree:

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

After Mauro pulls it, it will at some point go into his git-tree on 
kernel.org:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=summary

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

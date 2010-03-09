Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o29M5hN3013590
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 17:05:43 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o29M5UMI005510
	for <video4linux-list@redhat.com>; Tue, 9 Mar 2010 17:05:30 -0500
Date: Tue, 9 Mar 2010 23:05:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arno Euteneuer <arno.euteneuer@toptica.com>
Subject: Re: soc-camera driver for i.MX25
In-Reply-To: <4B960AE2.3090803@toptica.com>
Message-ID: <Pine.LNX.4.64.1003092256140.4891@axis700.grange>
References: <4B960AE2.3090803@toptica.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 9 Mar 2010, Arno Euteneuer wrote:

> Hi,
> I wrote a soc-camera driver for the i.MX25 which seems to work well on my
> setup with a monochrome mt9m001 camera chip if I use the full resolution of
> 10bits x 1280 x 1024 and up to three buffers. However, reducing the frame size
> to e.g. 640 x 480 leads to corrupted pictures sometimes when using multiple
> buffers. Using only one buffer for single shots seems to work always.
> Unfortunately for my application I don't need streaming at all and single
> shots is all I need, which is why I will have to stop working on this topic
> soon and focus on my user space problem again. Furthermore I will not be able
> to test it with other camera chips.
> Nevertheless I would like to contribute my work. Maybe somebody is interested
> or even is able to improve it.
> The patch is against kernel 2.6.31 (sorry).

Nice, thanks for the patch! Now, you'd have to formalise the submission - 
add your Signed-off-by line, provide a suitable patch description. More 
importantly, it certainly has to be updated for 2.6.32 and 2.6.33 - the 
biggest change since 2.6.31 has been the conversion to the v4l2-subdev 
API, and a smaller one - the addition of the mediabus API. For a single 
driver these are not very big changes, I could help you with them, but you 
certainly would have to re-test your setup with the current kernel. Would 
you be able to do that? And then, of course, we'd also have to pass your 
driver through the usual review rounds.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

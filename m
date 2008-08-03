Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m738i5R6027837
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 04:44:06 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m738hsuU026530
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 04:43:54 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Rabin Vincent <rabin@rab.in>
In-Reply-To: <20080803073705.GA2754@debian>
References: <82e4877d0808020922x64177318j6f8fe15955704521@mail.gmail.com>
	<20080803073705.GA2754@debian>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 03 Aug 2008 10:04:28 +0200
Message-Id: <1217750668.1714.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: gspca_zc3xx oops - 2.6.27-rc1
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

On Sun, 2008-08-03 at 13:07 +0530, Rabin Vincent wrote:
	[snip]
> Now sd->gamma shouldn't be zero because in sd_ctrls, the minimum value for it
> is set to 1.  This range should be checked by vidioc_s_ctrl in gspca.c, and we
> have this there:
> 
>                if (ctrl->value < ctrls->qctrl.minimum
>                    && ctrl->value > ctrls->qctrl.maximum)
>                         return -ERANGE;
> 
> There's a typo in this check, so userspace is able to set gamma to zero, and
> the crash happens when streaming is started.

Thank you! I did see the gamma was null, but I was searching for some
array overflow...

> Could you please try the patch below?
> 
> >From 6827a2973d512479c8cf61d4a7ae1b6c4099b65b Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Sun, 3 Aug 2008 12:00:04 +0530
> Subject: [PATCH] gspca: Fix ioctl range checking
	[snip]

In which list did you post?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0505LqK014462
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 19:05:21 -0500
Received: from mail05.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0504RNK019033
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 19:04:28 -0500
Date: Mon, 05 Jan 2009 09:04:19 +0900
From: morimoto.kuninori@renesas.com
In-reply-to: <Pine.LNX.4.64.0812271820480.4409@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <uhc4e7h4s.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
References: <umyejiigq.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812271820480.4409@axis700.grange>
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] fix try_fmt calculation method for ov772x driver
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


Dear Guennadi

Thank you for checking my patch

> For patches touching more than about 3 lines, a description is very 
> helpful (which doesn't mean, of course, that anything below 4 lines needs 
> no description:-)). Yes, I understand what you're fixing here, but saying 
> something like
> 
> Don't modify driver's state in try_fmt, just verify format acceptability 
> or adjust it to driver's capabilities.
> 
> Would help. If you agree with the above description, please, just ack it 
> and I'll insert it for you in the patch. Or you can certainly suggest your 
> own description.

I agree

Best regards
--
Kuninori Morimoto
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

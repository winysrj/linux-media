Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n63LPcDG031976
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 17:25:38 -0400
Received: from mail-vw0-f178.google.com (mail-vw0-f178.google.com
	[209.85.212.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n63LPLOq005365
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 17:25:21 -0400
Received: by vwj8 with SMTP id 8so1581214vwj.23
	for <video4linux-list@redhat.com>; Fri, 03 Jul 2009 14:25:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246654555282-3203325.post@n2.nabble.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
Date: Fri, 3 Jul 2009 17:25:21 -0400
Message-ID: <829197380907031425y4cf527fp9bfba46e00bc14d@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: buhochileno <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
	No Composite Input
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

On Fri, Jul 3, 2009 at 4:55 PM, buhochileno<buhochileno@gmail.com> wrote:
> Hi, I'm on the same situation, any sucess?
>
> May be this is a v4l2 or ucv device...
>
> Mauricio

This was fixed a couple of weeks ago.  Please update to the latest
v4-dvb code and the device should work properly now.

http://linuxtv.org/repo

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

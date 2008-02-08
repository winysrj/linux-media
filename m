Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m189Y4ab016034
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 04:34:05 -0500
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m189XWik014203
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 04:33:32 -0500
From: Michel Xhaard <mxhaard@magic.fr>
To: video4linux-list@redhat.com
Date: Fri, 8 Feb 2008 11:33:11 +0100
References: <47AB0FB0.5070503@seiner.com>
In-Reply-To: <47AB0FB0.5070503@seiner.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200802081133.11803.mxhaard@magic.fr>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: hardware requirements for webcams?
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

Le jeudi 7 février 2008 15:03, Yan Seiner a écrit :
> Hi everyone:
>
> I need to build an embedded platform that can handle 2 webcams,
> preferably at 640x480.  I've tested several typical embedded boards,
> with 200 MHz arm or mips CPUs, and they can handle 1 webcam at 480x320.
>
> Googling on webcams indicates that each webcam would have to have its
> own USB controller as well as enough CPU horsepower to do the job (maybe
> something in the 800 MHz range?)
>
> Is anyone aware of an inexpensive fanless board that could do this?  Or
> could provide some pointers on where I can look?
>
> Thanks,
>
> --Yan
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
Look for Via mini/nano itx board:
http://www.mini-box.com/s.nl/sc.8/category.99/.f
regards
-- 
Michel Xhaard
http://mxhaard.free.fr

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

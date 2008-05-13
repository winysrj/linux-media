Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D77m3U026804
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 03:07:48 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4D77b3K004314
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 03:07:38 -0400
Received: by ti-out-0910.google.com with SMTP id 24so1070514tim.7
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 00:07:36 -0700 (PDT)
Message-ID: <998e4a820805130007tf1ea6fdvc4aa799e75840cc5@mail.gmail.com>
Date: Tue, 13 May 2008 15:07:33 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Mike Rapoport" <mike@compulab.co.il>
In-Reply-To: <48292AC1.3020505@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <998e4a820805121959q77b3197cj692b813da6c68a7@mail.gmail.com>
	<48292AC1.3020505@compulab.co.il>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: writting norflash will affect capture on pxa270?
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

2008/5/13 Mike Rapoport <mike@compulab.co.il>:
>  NOR flash writes are *slow*, so this indeed can be an issue.

But I write a big file to nandflash.FIFO overrun do not occur.

thanks
fengxin


-- 
ÖÂ
Àñ
·ëöÎ

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

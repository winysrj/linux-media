Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D2xuhn032492
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 22:59:56 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4D2xjjR019839
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 22:59:45 -0400
Received: by ti-out-0910.google.com with SMTP id 24so1035224tim.7
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 19:59:44 -0700 (PDT)
Message-ID: <998e4a820805121959q77b3197cj692b813da6c68a7@mail.gmail.com>
Date: Tue, 13 May 2008 10:59:44 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: writting norflash will affect capture on pxa270?
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

My platform is pxa270.
When pxa270 is capturring, I write a file to JFFS2 norflash.Then FIFO
will overrun.But if I write a file to YAFFS nandflash,FIFO will not
overrun.

-- 
ÖÂ
Àñ
·ëöÎ

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

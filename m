Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n33Jaqpp028259
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 15:36:53 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n33JaXIm005839
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 15:36:33 -0400
Received: by gxk19 with SMTP id 19so2661315gxk.3
	for <video4linux-list@redhat.com>; Fri, 03 Apr 2009 12:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cb69f9670904031221s23122b03i8c4002c54cd612df@mail.gmail.com>
References: <cb69f9670904031221s23122b03i8c4002c54cd612df@mail.gmail.com>
Date: Fri, 3 Apr 2009 15:36:33 -0400
Message-ID: <412bdbff0904031236u5bf32a5ald6615abe86076cb6@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: kenny wang <smartkenny@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Question about analog mode of WinTV-HVR-950Q
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

On Fri, Apr 3, 2009 at 3:21 PM, kenny wang <smartkenny@gmail.com> wrote:
> Hi, all
>
> I have a WinTV-HVR-950Q and analog cable. The device works for ATSC on linux
> 2.6.29.1-git, but I want to use it with the analog cable. My question is:
> under the analog mode, is it /dev/vedio0 or /dev/dvb/adapter0?
>
> Thanks.
>
> Kenny

Analog mode is under /dev/video0.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

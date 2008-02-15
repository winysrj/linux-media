Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FIILwf029862
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:18:21 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FIHm1u013100
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:17:48 -0500
Message-ID: <47B5D754.4070103@free.fr>
Date: Fri, 15 Feb 2008 19:17:56 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
References: <1202915751-9326-1-git-send-email-jirislaby@gmail.com>
	<1202915751-9326-4-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1202915751-9326-4-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 4/4] v4l2_extension: grab real driver reference
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

Jiri Slaby a écrit :
> From: Jiri Slaby <ku@bellona.localdomain>
>
> Before opening real backing device, make sure, it is there and not going away.
> Drop the reference after release and failing open.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
All this patch series is comitted in
http://linuxtv.org/hg/~tmerle/v4l2_extension , thanks.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BKGoa9005457
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 15:16:50 -0500
Received: from mail.aknet.ru (mail.aknet.ru [78.158.192.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0BKFa2C021052
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 15:15:36 -0500
Message-ID: <496A53F2.7060103@aknet.ru>
Date: Sun, 11 Jan 2009 23:17:54 +0300
From: Stas Sergeev <stsp@aknet.ru>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <4968EE9A.5040901@aknet.ru> <20090111202504.644c2bb0@free.fr>
In-Reply-To: <20090111202504.644c2bb0@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [patch] add video_nr module param to gspca
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

Hello.

Jean-Francois Moine wrote:
> I don't think such a patch is usefull.
> Instead, as every system runs udev, it is simpler to add a rule as:
>   ATTRS{idVendor}=="05e1",ATTRS{idProduct}=="0893",NAME="video3"
Other drivers do have that modparam,
namely, I copy/pasted from cpia2_v4l.c.
So I thought it would be a good idea
to have it at least for consistency,
but thanks for the udev hint!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23HXkHW008621
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 12:33:46 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m23HXDva022307
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 12:33:13 -0500
Message-ID: <47CC365B.8010003@free.fr>
Date: Mon, 03 Mar 2008 18:33:15 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
References: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [RFC 1/1] v4l2_extension: helper daemon commands passing
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
> Here I would like to know if the the commands passing interface to the
> helper daemon introduced in this patch is OK, or alternatively propose
> some other idea ;).
>
>   

I have committed your patch as is
http://linuxtv.org/hg/~tmerle/v4l2_extension/
Now will begin a driver enhancement. I will do that on usbvision because
I know it.
The first step will be to extend the supported video formats (2
sub-steps: 1-just enable hardware pixel format capabilities in
usbvision, 2-allow the helper daemon to extend usbvision pixel format
capabilities).

Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

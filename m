Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBSKZVF3002893
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 15:35:33 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBSKYdp4014909
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 15:34:39 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1691492qwe.39
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 12:34:39 -0800 (PST)
Date: Sun, 28 Dec 2008 18:34:33 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: MrUmunhum@popdial.com
Message-ID: <20081228183433.1b35c464@gmail.com>
In-Reply-To: <4956E4C6.8040506@popdial.com>
References: <4956E4C6.8040506@popdial.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: eMPIA camera support?
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

Hello William,

On Sat, 27 Dec 2008 18:30:30 -0800
William Estrada <MrUmunhum@popdial.com> wrote:

> How can I get my cheapO eMPIA canera working on FC9 with a 2.6.28
> kernel? I have tried uvcvideo and em28xx but no joy.

Yes, please send to mail-list:

1) lsusb output
shell> lsusb > lsusb-output.txt

2) dmesg 
shell> dmesg > dmesg-output.txt

3) Model 

4) Brand

4) If possible, photos (outside and inside)
   You can use bttv galery: http://www.bttv-gallery.de/

I received an em28xx based webcam (SilverCrest), I'm working to add
support for it ASAP.

Thanks,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

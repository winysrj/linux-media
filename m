Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I0cFbu032029
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 20:38:15 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I0c3Dx031258
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 20:38:03 -0400
Received: by wr-out-0506.google.com with SMTP id c49so1850778wra.19
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:38:03 -0700 (PDT)
Date: Sun, 17 Aug 2008 19:29:02 -0500
To: video4linux-list@redhat.com
Message-ID: <20080818002902.GA22438@pippin.gateway.2wire.net>
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
From: Mark Ferrell <majortrips@gmail.com>
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Sun, Aug 17, 2008 at 09:48:58PM +0200, Theou Jean-Baptiste wrote:
> Hi. I'm the EasyCam Dev, a ubuntu software who make the webcam install
> easier ( I hope )
> I use this patch in my software. One user had try this patch, and after
> install, he observe in dmesg output :
> 
> [21222.334007] usb 1-2: new high speed USB device using ehci_hcd and address
> 9
> [21222.395446] usb 1-2: configuration #1 chosen from 1 choice
> [21222.399771] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: OmniVision
> OV534 compatible webcam detected
> [21222.399778] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: 06f8:3002
> Hercules Blog Webcam found
> [21222.438333] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: ov534
> controlling video device -1

The -1 is the minor number assigned after video_register_device().
This can set an invalid minor number while still returning success?

> Thanks you very much for your job
> 
> Best regards, and sorry for my bad english
> 
> -- 
> Jean-Baptiste Th?ou
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

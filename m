Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HJnait011063
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:49:36 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HJmxqL001145
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:48:59 -0400
Received: by rv-out-0506.google.com with SMTP id f6so3835011rvb.51
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 12:48:59 -0700 (PDT)
Message-ID: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
Date: Sun, 17 Aug 2008 21:48:58 +0200
From: "Theou Jean-Baptiste" <jbtheou@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
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

Hi. I'm the EasyCam Dev, a ubuntu software who make the webcam install
easier ( I hope )
I use this patch in my software. One user had try this patch, and after
install, he observe in dmesg output :

[21222.334007] usb 1-2: new high speed USB device using ehci_hcd and addres=
s
9
[21222.395446] usb 1-2: configuration #1 chosen from 1 choice
[21222.399771] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: OmniVision
OV534 compatible webcam detected
[21222.399778] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: 06f8:3002
Hercules Blog Webcam found
[21222.438333] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: ov534
controlling video device -1

Thanks you very much for your job

Best regards, and sorry for my bad english

--=20
Jean-Baptiste Th=E9ou
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

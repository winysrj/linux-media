Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HKDpmm027673
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 16:13:51 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HKDhbJ013445
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 16:13:43 -0400
Received: by rv-out-0506.google.com with SMTP id f6so3848211rvb.51
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 13:13:42 -0700 (PDT)
Message-ID: <6f278f100808171313j2764641ase8076781993f9a8e@mail.gmail.com>
Date: Sun, 17 Aug 2008 22:13:42 +0200
From: "Theou Jean-Baptiste" <jbtheou@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
MIME-Version: 1.0
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
	<6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
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

One more thing again ......
It seems to be "dev->vfd->minor" (line 1339) who return '-1'
If this info can help you .....

2008/8/17 Theou Jean-Baptiste <jbtheou@gmail.com>

> One more thing, when he halt in her system, the halt "freeze", and when h=
e
> unplugged her webcam, he observe that :
>
> /dev/video-1 released
>
> 2008/8/17 Theou Jean-Baptiste <jbtheou@gmail.com>
>
> Hi. I'm the EasyCam Dev, a ubuntu software who make the webcam install
>> easier ( I hope )
>> I use this patch in my software. One user had try this patch, and after
>> install, he observe in dmesg output :
>>
>> [21222.334007] usb 1-2: new high speed USB device using ehci_hcd and
>> address 9
>> [21222.395446] usb 1-2: configuration #1 chosen from 1 choice
>> [21222.399771] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: OmniVision
>> OV534 compatible webcam detected
>> [21222.399778] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: 06f8:3002
>> Hercules Blog Webcam found
>> [21222.438333] /usr/share/EasyCam2/drivers/ov534/v4l/ov534.c: ov534
>> controlling video device -1
>>
>> Thanks you very much for your job
>>
>> Best regards, and sorry for my bad english
>>
>> --
>> Jean-Baptiste Th=E9ou
>>
>
>
>
> --
> Jean-Baptiste Th=E9ou
>



--=20
Jean-Baptiste Th=E9ou
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

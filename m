Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KECjsX017832
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:12:45 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KECXJP015271
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 10:12:34 -0400
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id m6KECX8L091111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>;
	Sun, 20 Jul 2008 16:12:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 20 Jul 2008 16:12:33 +0200
References: <de8cad4d0807200710xde576bfpb495ae5dbbd0b394@mail.gmail.com>
In-Reply-To: <de8cad4d0807200710xde576bfpb495ae5dbbd0b394@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807201612.33032.hverkuil@xs4all.nl>
Subject: Re: compat_ioctl32.o: Error compiling latest HG clone of v4l-dvb
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

On Sunday 20 July 2008 16:10:12 Brandon Jenkins wrote:
> Greetings,
>
> Snippet below.
>
> Thanks!

Working on it...

	Hans

>
> Brandon
>
> CC [M]  /root/v4l-dvb/v4l/compat_ioctl32.o
> /root/v4l-dvb/v4l/compat_ioctl32.c: In function 'v4l_compat_ioctl32':
> /root/v4l-dvb/v4l/compat_ioctl32.c:985: error: implicit declaration
> of function 'v4l_printk_ioctl'
> make[3]: *** [/root/v4l-dvb/v4l/compat_ioctl32.o] Error 1
> make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.26'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/root/v4l-dvb/v4l'
> make: *** [all] Error 2
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

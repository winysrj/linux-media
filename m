Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5FFM1ZG010632
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 11:22:01 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n5FFLgwX027989
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 11:21:42 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1897356qwd.39
	for <video4linux-list@redhat.com>; Mon, 15 Jun 2009 08:21:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906131224.57163.armin.nueckel@arcor.de>
References: <200906131224.57163.armin.nueckel@arcor.de>
Date: Mon, 15 Jun 2009 11:21:42 -0400
Message-ID: <829197380906150821x386bd0eck67caf4b54b368cb7@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Armin_N=FCckel?= <armin.nueckel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: Hauppauge USB 2.0 DVB-T WinTV-Nova-T-Stick Lite
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

On Sat, Jun 13, 2009 at 6:24 AM, Armin Nückel<armin.nueckel@arcor.de> wrote:
> Dear folks @ V4L List,
>
> I just write this, to mention some words on how to install and use the
<snip>
> This is, assuming v4l is installed, the firmware is missing. The latest working version on the net I found is the file:
>
>        dvb-usb-dib0700-1.20.fw
>
> now, the stick needs a file named
>
>        dvb-usb-dib0700-1.10.fw
>
> as reported above.
> Thus the latest firmware file needs to be renamed, and copied into the
>
>        /lib/firmware
>
> directory:
>
>        cp Desktop/dvb-usb-dib0700-1.20.fw /lib/firmware/dvb-usb-dib0700-1.10.fw
>
<snip>

Hello Armin,

Just one quick note on this: generally speaking, you should *never* be
renaming firmware files.  If it asks for 1.10, you need version 1.10.
There are often code changes that are based on the firmware version.

You can get 1.10 from here:

 http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw

Or, you can install the latest v4l-dvb code with the directions at
http://linuxtv.org/repo, which will then result in the driver using
the 1.20 firmware.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

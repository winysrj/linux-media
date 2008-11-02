Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA2Mr3GV018678
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 17:53:03 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA2Mqp5A013468
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 17:52:51 -0500
Received: by nf-out-0910.google.com with SMTP id d3so871144nfc.21
	for <video4linux-list@redhat.com>; Sun, 02 Nov 2008 14:52:50 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
	<30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 01:52:44 +0300
Message-Id: <1225666364.16097.24.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

Hello, all

On Wed, 2008-10-29 at 13:12 -0400, David Ellingsworth wrote:
> > you want my ack, you have the following options:
> >
> > 1. Use the same name used in the usb_driver struct
> > 2. Remove the name altogether
> >
> > If I were writing it, I'd do the following:
> >
> > #define DRVNAME "radio-mr800"
> > #define amradio_dev_err(dev, fmt, arg...) dev_err(dev, DRVNAME fmt, ##arg)
> > #define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, DRVNAME fmt, ##arg)
> Minor correction here ^^^^^
> 
> It should be:
> #define amradio_dev_err(dev, fmt, arg...) dev_err(dev, DRVNAME ": " fmt, ##arg)
> #define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, DRVNAME ": "
> fmt, ##arg)
> 
> - David Ellingsworth

You idea is great. I made patch, but have few questions.

May i use " - " in amradio_dev_info for example, instead of
using ..DRVNAME ": " fmt.. in defined macros? There are a lot of ":" in
messages if using ":".

May i use amradio_dev_info for cases where i want
&radio->videodev->dev ? And may i use usual dev_warn where intf->dev is
more apropriate ? Or you want me to use amradio_dev_warn macroses
everywhere ?

David, what do you think ?

Best regards,
Alexey Klimov

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9THCxtF003086
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:12:59 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9THC75S028722
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:12:07 -0400
Received: by ug-out-1314.google.com with SMTP id j30so1552713ugc.13
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 10:12:06 -0700 (PDT)
Message-ID: <30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
Date: Wed, 29 Oct 2008 13:12:06 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
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

On Wed, Oct 29, 2008 at 1:08 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Tue, Oct 28, 2008 at 1:05 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>> Hello, all
>>
>> Here is new patch, reformatted. Also KBUILD_MODNAME added.
>>
>> radio-mr800: remove warn-, err- and info-messages
>>
>> Patch removes warn(), err() and info() statements in radio/radio-mr800.c,
>> and place dev_warn, dev_info in right places.
>> Printk changed on pr_info and pr_err macro.
>>
>> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>>
>
> NACK. KBIULD_MODNAME should not be used except from within module
> specific function (IE module_init and module_exit routines). It is my
> understanding that KBUILD_MODNAME expands to the name module when the
> driver is compiled as a module and the name of the file otherwise.
> While I understand this is how the previous warn() and err() macros
> were defined in usb.h I don't believe it's the right thing to do. If
> you want my ack, you have the following options:
>
> 1. Use the same name used in the usb_driver struct
> 2. Remove the name altogether
>
> If I were writing it, I'd do the following:
>
> #define DRVNAME "radio-mr800"
> #define amradio_dev_err(dev, fmt, arg...) dev_err(dev, DRVNAME fmt, ##arg)
> #define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, DRVNAME fmt, ##arg)
Minor correction here ^^^^^

It should be:
#define amradio_dev_err(dev, fmt, arg...) dev_err(dev, DRVNAME ": " fmt, ##arg)
#define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, DRVNAME ": "
fmt, ##arg)

- David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

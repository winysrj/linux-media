Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TH9GnK032275
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:09:16 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9TH8RTh026086
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:08:30 -0400
Received: by ey-out-2122.google.com with SMTP id 4so41845eyf.39
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 10:08:27 -0700 (PDT)
Message-ID: <30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
Date: Wed, 29 Oct 2008 13:08:26 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <20081028180552.GA2677@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
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

On Tue, Oct 28, 2008 at 1:05 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello, all
>
> Here is new patch, reformatted. Also KBUILD_MODNAME added.
>
> radio-mr800: remove warn-, err- and info-messages
>
> Patch removes warn(), err() and info() statements in radio/radio-mr800.c,
> and place dev_warn, dev_info in right places.
> Printk changed on pr_info and pr_err macro.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>

NACK. KBIULD_MODNAME should not be used except from within module
specific function (IE module_init and module_exit routines). It is my
understanding that KBUILD_MODNAME expands to the name module when the
driver is compiled as a module and the name of the file otherwise.
While I understand this is how the previous warn() and err() macros
were defined in usb.h I don't believe it's the right thing to do. If
you want my ack, you have the following options:

1. Use the same name used in the usb_driver struct
2. Remove the name altogether

If I were writing it, I'd do the following:

#define DRVNAME "radio-mr800"
#define amradio_dev_err(dev, fmt, arg...) dev_err(dev, DRVNAME fmt, ##arg)
#define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, DRVNAME fmt, ##arg)

Update the name member of the usb_driver struct to use DRVNAME rather
than the constant string it has there.
Use amradio_dev_err and amradio_dev_warn wherever dev_err or dev_warn is needed.

By doing it this way, the code stays clean, consistent and easily maintainable.

-------------
On a related note, the name stored in the usb_driver struct gets
transferred to a device struct by the usb subsystem. In a perfect
world, I believe this struct would be the right one to pass to dev_err
and dev_warn directly. Unfortunately though, that device struct is
buried within usb specific structures and gaining access to is
difficult and could be problematic in the future. It is for this
reason I don't advocate its use. Having said that, I think it would be
OK to use pr_err and pr_warn instead of dev_err and dev_warn here
since we really don't have access to the appropriate device struct.
That said, I'd also ack a patch which redefined the above macros to
use pr_err and pr_warning rather than dev_err and dev_warn and renamed
them appropriately.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

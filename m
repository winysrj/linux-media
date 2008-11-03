Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3H3Dw3019838
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:03:14 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3H1JDZ012800
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:01:30 -0500
Received: by ey-out-2122.google.com with SMTP id 4so773740eyf.39
	for <video4linux-list@redhat.com>; Mon, 03 Nov 2008 09:01:18 -0800 (PST)
Message-ID: <30353c3d0811030901y3e7b2699s605fb5de63aa0446@mail.gmail.com>
Date: Mon, 3 Nov 2008 12:01:18 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Carl Karsten" <carl@personnelware.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
In-Reply-To: <490F2AE8.2060002@personnelware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
	<30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
	<1225728173.20921.6.camel@tux.localhost>
	<30353c3d0811030819k4e6610d6u4188b940a40b02f5@mail.gmail.com>
	<490F2AE8.2060002@personnelware.com>
Cc: 
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

On Mon, Nov 3, 2008 at 11:46 AM, Carl Karsten <carl@personnelware.com> wrote:
> David Ellingsworth wrote:
>> [snip]
>>>  #define USB_AMRADIO_VENDOR 0x07ca
>>>  #define USB_AMRADIO_PRODUCT 0xb800
>>> +
>>> +/* dev_warn macro with driver name */
>>> +#define DRIVERNAME "radio-mr800"
>>
>> should probably be DRIVER_NAME
>>
>
> I think it should be unique, based on
>
> vivi: rename MODULE_NAME macro to VIVI_MODULE_NAME to avoid namespace conflicts
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> -#define MODULE_NAME "vivi"
> +#define VIVI_MODULE_NAME "vivi"
>
> http://linuxtv.org/hg/v4l-dvb/rev/58b95134acb8.
>
> and
>  #define VIVI_MODULE_NAME "vivi"
>
> http://linuxtv.org/hg/v4l-dvb/file/50e4cdc46320/linux/drivers/media/video/vivi.c
>
> Carl K
>

Carl is right. Carl, please stay on-list next time.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBLL0V0R022836
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 16:00:31 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBLL0Ih5005796
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 16:00:18 -0500
Received: by bwz13 with SMTP id 13so4933616bwz.3
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 13:00:18 -0800 (PST)
Message-ID: <208cbae30812211300l537445a1n76118650949b0567@mail.gmail.com>
Date: Mon, 22 Dec 2008 00:00:18 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Thierry Merle" <thierry.merle@free.fr>
In-Reply-To: <208cbae30812211251h2a310a07v5b046cbe3a24fd1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229742563.10297.114.camel@tux.localhost>
	<20081220132730.45e9c365@gmail.com>
	<30353c3d0812200959h40d525f0t6939c21c6bd4e612@mail.gmail.com>
	<1229885212.12091.219.camel@tux.localhost> <494EA35F.10208@free.fr>
	<208cbae30812211251h2a310a07v5b046cbe3a24fd1e@mail.gmail.com>
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [review patch 2/5] dsbr100: fix codinstyle, make ifs more clear
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

<snip>

>> I would use a goto.
>> This is the most readable and efficient way to manage exeptions in C.
>> Take a look at linux/drivers/media/video/v4l2-dev.c for an example of goto usage.
>> Cheers,
>> Thierry
>
> So, do you mean that i can use this method ?
>
> static int dsbr100_stop(struct dsbr100_device *radio)
> {
>        int retval;
>        int request;
>
>        mutex_lock(&radio->lock);
>
>        retval = usb_control_msg(radio->usbdev,
>                usb_rcvctrlpipe(radio->usbdev, 0),
>                USB_REQ_GET_STATUS,
>                USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>                0x16, 0x1C, radio->transfer_buffer, 8, 300);
>
>        if (retval < 0) {
>                request = USB_REQ_GET_STATUS;
>                goto usb_control_msg_failed;
>        }
>
>        retval = usb_control_msg(radio->usbdev,
>                usb_rcvctrlpipe(radio->usbdev, 0),
>                DSB100_ONOFF,
>                USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>                0x00, 0x00, radio->transfer_buffer, 8, 300);
>
>        if (retval < 0) {
>                request = DSB100_ONOFF;
>                goto usb_control_msg_failed;
>        }
>
>        radio->muted=1;
>        mutex_unlock(&radio->lock);
>        return (radio->transfer_buffer)[0];
>
> :usb_control_msg_failed:

Oh, sorry. Of course, there is no ":" before usb_control_msg_failed.
Only after.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

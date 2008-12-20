Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBKHxfBU011550
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 12:59:41 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBKHxSo1020638
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 12:59:28 -0500
Received: by bwz13 with SMTP id 13so4107752bwz.3
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 09:59:28 -0800 (PST)
Message-ID: <30353c3d0812200959h40d525f0t6939c21c6bd4e612@mail.gmail.com>
Date: Sat, 20 Dec 2008 12:59:27 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Douglas Schilling Landgraf" <dougsland@gmail.com>
In-Reply-To: <20081220132730.45e9c365@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229742563.10297.114.camel@tux.localhost>
	<20081220132730.45e9c365@gmail.com>
Cc: video4linux-list@redhat.com
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

On Sat, Dec 20, 2008 at 10:27 AM, Douglas Schilling Landgraf
<dougsland@gmail.com> wrote:
> Hello Alexey,
>
> On Sat, 20 Dec 2008 06:09:23 +0300
> Alexey Klimov <klimov.linux@gmail.com> wrote:
>
>> We should make if-constructions more clear. Introduce int variables in
>> some functions to make it this way.
>>
>> ---
>> diff -r a302bfcb23f8 linux/drivers/media/radio/dsbr100.c
>> --- a/linux/drivers/media/radio/dsbr100.c     Fri Dec 19 14:34:30
>> 2008 +0300 +++ b/linux/drivers/media/radio/dsbr100.c  Sat Dec
>> 20 02:31:26 2008 +0300 @@ -200,15 +200,24 @@
>>  /* switch on radio */
>>  static int dsbr100_start(struct dsbr100_device *radio)
>>  {
>> +     int first;
>> +     int second;
>> +
>>       mutex_lock(&radio->lock);
>> -     if (usb_control_msg(radio->usbdev,
>> usb_rcvctrlpipe(radio->usbdev, 0),
>> -                     USB_REQ_GET_STATUS,
>> -                     USB_TYPE_VENDOR | USB_RECIP_DEVICE |
>> USB_DIR_IN,
>> -                     0x00, 0xC7, radio->transfer_buffer, 8, 300)
>> < 0 ||
>> -     usb_control_msg(radio->usbdev,
>> usb_rcvctrlpipe(radio->usbdev, 0),
>> -                     DSB100_ONOFF,
>> -                     USB_TYPE_VENDOR | USB_RECIP_DEVICE |
>> USB_DIR_IN,
>> -                     0x01, 0x00, radio->transfer_buffer, 8, 300)
>> < 0) { +
>> +     first = usb_control_msg(radio->usbdev,
>> +             usb_rcvctrlpipe(radio->usbdev, 0),
>> +             USB_REQ_GET_STATUS,
>> +             USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>> +             0x00, 0xC7, radio->transfer_buffer, 8, 300);
>> +
>> +     second = usb_control_msg(radio->usbdev,
>> +             usb_rcvctrlpipe(radio->usbdev, 0),
>> +             DSB100_ONOFF,
>> +             USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>> +             0x01, 0x00, radio->transfer_buffer, 8, 300);
>> +
>> +     if (first < 0 || second < 0) {
>>               mutex_unlock(&radio->lock);
>>               return -1;
>>       }
>
> IMO, we could create a variable like "ret" or "retval" to validate each
> usb_control_msg call instead of create 3 variables "first", "second" and "third".

The primary problem I have with this patch is that it changes the
behavior of the driver. The original way it was written the function
would immediately return if one of the calls to usb_control_msg
failed. With this patch, if the first call fails it will still make a
second call to usb_control_msg.

I agree with Douglas, a single "ret" variable should be used and then
evaluated after every usb_control_msg call.

[snip]

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

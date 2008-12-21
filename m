Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBLKq5Qi020251
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 15:52:05 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBLKppTh002141
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 15:51:52 -0500
Received: by bwz13 with SMTP id 13so4928412bwz.3
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 12:51:51 -0800 (PST)
Message-ID: <208cbae30812211251h2a310a07v5b046cbe3a24fd1e@mail.gmail.com>
Date: Sun, 21 Dec 2008 23:51:51 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Thierry Merle" <thierry.merle@free.fr>
In-Reply-To: <494EA35F.10208@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1229742563.10297.114.camel@tux.localhost>
	<20081220132730.45e9c365@gmail.com>
	<30353c3d0812200959h40d525f0t6939c21c6bd4e612@mail.gmail.com>
	<1229885212.12091.219.camel@tux.localhost> <494EA35F.10208@free.fr>
Content-Transfer-Encoding: 8bit
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

On Sun, Dec 21, 2008 at 11:13 PM, Thierry Merle <thierry.merle@free.fr> wrote:
> Hello,
>
> Alexey Klimov a écrit :
>> On Sat, 2008-12-20 at 12:59 -0500, David Ellingsworth wrote:
>>> On Sat, Dec 20, 2008 at 10:27 AM, Douglas Schilling Landgraf
>>> <dougsland@gmail.com> wrote:
>>>> Hello Alexey,
>>>>
>>>> On Sat, 20 Dec 2008 06:09:23 +0300
>>>> Alexey Klimov <klimov.linux@gmail.com> wrote:
>>>>
>>>>> We should make if-constructions more clear. Introduce int variables in
>>>>> some functions to make it this way.
>>>>>
>>>>> ---
>>>>> diff -r a302bfcb23f8 linux/drivers/media/radio/dsbr100.c
>>>>> --- a/linux/drivers/media/radio/dsbr100.c     Fri Dec 19 14:34:30
>>>>> 2008 +0300 +++ b/linux/drivers/media/radio/dsbr100.c  Sat Dec
>>>>> 20 02:31:26 2008 +0300 @@ -200,15 +200,24 @@
>>>>>  /* switch on radio */
>>>>>  static int dsbr100_start(struct dsbr100_device *radio)
>>>>>  {
>>>>> +     int first;
>>>>> +     int second;
>>>>> +
>>>>>       mutex_lock(&radio->lock);
>>>>> -     if (usb_control_msg(radio->usbdev,
>>>>> usb_rcvctrlpipe(radio->usbdev, 0),
>>>>> -                     USB_REQ_GET_STATUS,
>>>>> -                     USB_TYPE_VENDOR | USB_RECIP_DEVICE |
>>>>> USB_DIR_IN,
>>>>> -                     0x00, 0xC7, radio->transfer_buffer, 8, 300)
>>>>> < 0 ||
>>>>> -     usb_control_msg(radio->usbdev,
>>>>> usb_rcvctrlpipe(radio->usbdev, 0),
>>>>> -                     DSB100_ONOFF,
>>>>> -                     USB_TYPE_VENDOR | USB_RECIP_DEVICE |
>>>>> USB_DIR_IN,
>>>>> -                     0x01, 0x00, radio->transfer_buffer, 8, 300)
>>>>> < 0) { +
>>>>> +     first = usb_control_msg(radio->usbdev,
>>>>> +             usb_rcvctrlpipe(radio->usbdev, 0),
>>>>> +             USB_REQ_GET_STATUS,
>>>>> +             USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>>>> +             0x00, 0xC7, radio->transfer_buffer, 8, 300);
>>>>> +
>>>>> +     second = usb_control_msg(radio->usbdev,
>>>>> +             usb_rcvctrlpipe(radio->usbdev, 0),
>>>>> +             DSB100_ONOFF,
>>>>> +             USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>>>> +             0x01, 0x00, radio->transfer_buffer, 8, 300);
>>>>> +
>>>>> +     if (first < 0 || second < 0) {
>>>>>               mutex_unlock(&radio->lock);
>>>>>               return -1;
>>>>>       }
>>>> IMO, we could create a variable like "ret" or "retval" to validate each
>>>> usb_control_msg call instead of create 3 variables "first", "second" and "third".
>>> The primary problem I have with this patch is that it changes the
>>> behavior of the driver. The original way it was written the function
>>> would immediately return if one of the calls to usb_control_msg
>>> failed. With this patch, if the first call fails it will still make a
>>> second call to usb_control_msg.
>>>
>>> I agree with Douglas, a single "ret" variable should be used and then
>>> evaluated after every usb_control_msg call.
>>>
>>> [snip]
>>>
>>> Regards,
>>>
>>> David Ellingsworth
>>
>> Hello, all
>> Yes, you are right, my bad - i missed that thing.
>>
>> Also, it's better to add dev_err messages that reports in case of
>> retval<0 what usb_control_msg returned, request and what function it
>> was.
>>
>> I suppose example could look like this:
>>
>> static int dsbr100_start(struct dsbr100_device *radio)
>> {
>>         int retval;
>>
>>         mutex_lock(&radio->lock);
>>
>>         retval = usb_control_msg(radio->usbdev,
>>                 usb_rcvctrlpipe(radio->usbdev, 0),
>>                 USB_REQ_GET_STATUS,
>>                 USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>                 0x00, 0xC7, radio->transfer_buffer, 8, 300);
>>
>>         if (retval < 0) {
>>                 mutex_unlock(&radio->lock);
>>                 dev_err(&radio->usbdev->dev,
>>                         "usb_control_msg returned %i, request %i in %s\n",
>>                               retval, USB_REQ_GET_STATUS, __func__);
>>                 return -1;
>>         }
>>
>>         retval = usb_control_msg(radio->usbdev,
>>                 usb_rcvctrlpipe(radio->usbdev, 0),
>>                 DSB100_ONOFF,
>>                 USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>                 0x01, 0x00, radio->transfer_buffer, 8, 300);
>>
>>         if (retval < 0) {
>>                 mutex_unlock(&radio->lock);
>>                 dev_err(&radio->usbdev->dev,
>>                         "usb_control_msg returned %i, request %i in %s\n",
>>                               retval, DSB100_ONOFF, __func__);
>>                 return -1;
>>         }
>> ...<snip>
>>
>> But it looks, that more comfortable to create macro, may be smth that looks like:
>>
>> #define dsbr_usb_control_msg_err(arg)                                   \
>>                 dev_err(&radio->usbdev->dev,                          \
>>                         "%s - usb_control_msg returned %i, request %i\n",\
>>                                 __func__, retval, arg)
>>
>> And then i can use:
>>
>>         retval = usb_control_msg(radio->usbdev,
>>                 usb_rcvctrlpipe(radio->usbdev, 0),
>>                 USB_REQ_GET_STATUS,
>>                 USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>                 0x00, 0xC7, radio->transfer_buffer, 8, 300);
>>
>>         if (retval < 0) {
>>                 mutex_unlock(&radio->lock);
>>                 dsbr_usb_control_msg_err(USB_REQ_GET_STATUS);
>>                 return -1;
>>         }
>>
>>         retval = usb_control_msg(radio->usbdev,
>>                 usb_rcvctrlpipe(radio->usbdev, 0),
>>                 DSB100_ONOFF,
>>                 USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
>>                 0x01, 0x00, radio->transfer_buffer, 8, 300);
>>
>>         if (retval < 0) {
>>                 mutex_unlock(&radio->lock);
>>                 dsbr_usb_control_msg_err(DSB100_ONOFF);
>>                 return -1;
>>         }
>>
>> We should see what function and request failed.
>> I didn't mean that this is right thing, it's just approach, that i can
>> offer.
>>
>> What do you think ?
>>
>>
> I would use a goto.
> This is the most readable and efficient way to manage exeptions in C.
> Take a look at linux/drivers/media/video/v4l2-dev.c for an example of goto usage.
> Cheers,
> Thierry

So, do you mean that i can use this method ?

static int dsbr100_stop(struct dsbr100_device *radio)
{
        int retval;
        int request;

        mutex_lock(&radio->lock);

        retval = usb_control_msg(radio->usbdev,
                usb_rcvctrlpipe(radio->usbdev, 0),
                USB_REQ_GET_STATUS,
                USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
                0x16, 0x1C, radio->transfer_buffer, 8, 300);

        if (retval < 0) {
                request = USB_REQ_GET_STATUS;
                goto usb_control_msg_failed;
        }

        retval = usb_control_msg(radio->usbdev,
                usb_rcvctrlpipe(radio->usbdev, 0),
                DSB100_ONOFF,
                USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
                0x00, 0x00, radio->transfer_buffer, 8, 300);

        if (retval < 0) {
                request = DSB100_ONOFF;
                goto usb_control_msg_failed;
        }

        radio->muted=1;
        mutex_unlock(&radio->lock);
        return (radio->transfer_buffer)[0];

:usb_control_msg_failed:

        mutex_unlock(&radio->lock);
        dev_err(&radio->usbdev->dev,
                "%s - usb_control_msg returned %i, request %i\n",
                        __func__, retval, request);
        return -1;
}

And i have to make it in three functions ?

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

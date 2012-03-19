Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33177 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2CSLah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 07:30:37 -0400
Received: by yhmm54 with SMTP id m54so5339363yhm.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 04:30:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96767C26EA89B648B398B4BCB10B3F635F0FFD779B@DIAMANT.xi-lite.lan>
References: <1331901909-4960-1-git-send-email-santoshprasadnayak@gmail.com>
	<CAOD=uF6568Gp_Zir+u3O5O8srZGzqcdSMQ9eppcao0d8Bdkwxw@mail.gmail.com>
	<96767C26EA89B648B398B4BCB10B3F635F0FFD779B@DIAMANT.xi-lite.lan>
Date: Mon, 19 Mar 2012 17:00:36 +0530
Message-ID: <CAOD=uF5DH2Y5cGZjsYdF2aiyZt5bSVaXLOe+EvtJDp28UjWVjw@mail.gmail.com>
Subject: Re: [PATCH] [media] dib0700: Return -EINTR and unlock mutex if
 locking attempts fails.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Olivier GRENIE <olivier.grenie@parrot.com>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
	"pboettcher@kernellabs.com" <pboettcher@kernellabs.com>,
	"florian@mickler.org" <florian@mickler.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olivier,

Included your suggestion and sent a new patch.
Please review it.


regards
Santosh

On Mon, Mar 19, 2012 at 3:58 PM, Olivier GRENIE
<olivier.grenie@parrot.com> wrote:
> Hello,
> I agree with the patch. But you could also add:
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
> index 1a6ddbc..a271203 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
> @@ -178,7 +178,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
>        /* Ensure nobody else hits the i2c bus while we're sending our
>           sequence of messages, (such as the remote control thread) */
>        if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> -               return -EAGAIN;
> +               return -EINTR;
>
>        for (i = 0; i < num; i++) {
>                if (i == 0) {
> @@ -272,7 +272,7 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
>        int i,len;
>
>        if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> -               return -EAGAIN;
> +               return -EINTR;
>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>                err("could not acquire lock");
>                mutex_unlock(&d->i2c_mutex);
>
> regards,
> Olivier
>
> ________________________________________
> From: santosh prasad nayak [santoshprasadnayak@gmail.com]
> Sent: Monday, March 19, 2012 9:47 AM
> To: mchehab@infradead.org
> Cc: Olivier GRENIE; pboettcher@kernellabs.com; florian@mickler.org; gregkh@linuxfoundation.org; linux-media@vger.kernel.org
> Subject: Re: [PATCH] [media] dib0700: Return -EINTR and unlock mutex if locking attempts fails.
>
> Can anyone please review it ?
>
>
> regards
> Santosh
>
> On Fri, Mar 16, 2012 at 6:15 PM, santosh nayak
> <santoshprasadnayak@gmail.com> wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>>
>> In 'dib0700_i2c_xfer_new()' and 'dib0700_i2c_xfer_legacy()'
>> we are taking two locks:
>>                1. i2c_mutex
>>                2. usb_mutex
>> If attempt to take 'usb_mutex' lock fails then the previously taken
>> lock 'i2c_mutex' should be unlocked and -EINTR should be return so
>> that caller can take appropriate action.
>>
>> If locking attempt was interrupted by a signal then
>> we should return -EINTR. At present we are returning '0' for
>> such scenarios  which is wrong.
>>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  drivers/media/dvb/dvb-usb/dib0700_core.c |   20 +++++++++++---------
>>  1 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> index 070e82a..1a6ddbc 100644
>> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
>> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> @@ -32,7 +32,7 @@ int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
>>
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
>> @@ -118,7 +118,7 @@ int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_
>>
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        st->buf[0] = REQUEST_SET_GPIO;
>> @@ -139,7 +139,7 @@ static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
>>        if (st->fw_version >= 0x10201) {
>>                if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                        err("could not acquire lock");
>> -                       return 0;
>> +                       return -EINTR;
>>                }
>>
>>                st->buf[0] = REQUEST_SET_USB_XFER_LEN;
>> @@ -228,7 +228,8 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
>>                        /* Write request */
>>                        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                                err("could not acquire lock");
>> -                               return 0;
>> +                               mutex_unlock(&d->i2c_mutex);
>> +                               return -EINTR;
>>                        }
>>                        st->buf[0] = REQUEST_NEW_I2C_WRITE;
>>                        st->buf[1] = msg[i].addr << 1;
>> @@ -274,7 +275,8 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
>>                return -EAGAIN;
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               mutex_unlock(&d->i2c_mutex);
>> +               return -EINTR;
>>        }
>>
>>        for (i = 0; i < num; i++) {
>> @@ -369,7 +371,7 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
>>
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        st->buf[0] = REQUEST_SET_CLOCK;
>> @@ -401,7 +403,7 @@ int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz)
>>
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        st->buf[0] = REQUEST_SET_I2C_PARAM;
>> @@ -561,7 +563,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>>
>>        if (mutex_lock_interruptible(&adap->dev->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        st->buf[0] = REQUEST_ENABLE_VIDEO;
>> @@ -611,7 +613,7 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
>>
>>        if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>                err("could not acquire lock");
>> -               return 0;
>> +               return -EINTR;
>>        }
>>
>>        st->buf[0] = REQUEST_SET_RC;
>> --
>> 1.7.4.4
>>

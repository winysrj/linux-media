Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35280 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbeD1GBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 02:01:24 -0400
Received: by mail-qt0-f179.google.com with SMTP id s2-v6so5131915qti.2
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2018 23:01:24 -0700 (PDT)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com. [209.85.220.176])
        by smtp.gmail.com with ESMTPSA id z135sm2217714qka.1.2018.04.27.23.01.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Apr 2018 23:01:23 -0700 (PDT)
Received: by mail-qk0-f176.google.com with SMTP id d125so3144365qkb.8
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2018 23:01:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180427133311.5789da57@vento.lan>
References: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
 <20180409091441.GX4043@hirez.programming.kicks-ass.net> <CAAZRmGw9DTHX65cYch6ozjGejMnDNQx_aNF-RYPRo+E4COEoRA@mail.gmail.com>
 <18b9e776-3558-30ed-f616-a0ba8e4d177d@iki.fi> <CAAZRmGzvh_R_JPkD6sNC_qQddTrv0zCi3TEdGd-Si9qTc2HrLg@mail.gmail.com>
 <20180427133311.5789da57@vento.lan>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Sat, 28 Apr 2018 08:01:21 +0200
Message-ID: <CAAZRmGx3ySxtsy-23gD5ToaqLnMrS-V2id8qXEdHA1+naGe5nQ@mail.gmail.com>
Subject: Re: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Antti Palosaari <crope@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Nibble Max <nibble.max@gmail.com>,
        linux-media <linux-media@vger.kernel.org>, wsa@the-dreams.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I did test the patch and while it doesn't seem to introduce any
negative side effects it does not provide a remedy for the original
problem that was seen after introducing
9d659ae14b545c4296e812c70493bfdc999b5c1c (you probably did not expect
that either).


Cheers,
-olli

On 27 April 2018 at 18:33, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> Em Fri, 27 Apr 2018 16:25:08 +0200
> Olli Salonen <olli.salonen@iki.fi> escreveu:
>
>> Thanks for the suggestion Antti.
>>
>> I've tried to add a delay in various places, but haven't seen any
>> improvement. However, what I did saw was that if I added an msleep
>> after the lock:
>>
>> static int dvbsky_usb_generic_rw(struct dvb_usb_device *d,
>>                 u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
>> {
>>         int ret;
>>         struct dvbsky_state *state = d_to_priv(d);
>>
>>         mutex_lock(&d->usb_mutex);
>>         msleep(20);
>>
>> The error was seen very within a minute. If I increased the msleep to
>> 50, it failed within seconds. This doesn't seem to make sense to me.
>> This is the only function where usb_mutex is used. If the mutex is
>> held for a longer time, the next attempt to lock the mutex should just
>> be delayed a bit, no?
>
> I don't like the idea of having two mutexes there to protect reading/writing
> to data one for "generic" r/w ops, and another one just for streaming
> control, with ends by calling the "generic" mutex.
>
> IMHO, I would get rid of one of the mutexes, e. g. something like the
> patch below (untested).
>
> Regards,
> Mauro
>
> media: dvbsky: use just one mutex for serializing device R/W ops
>
> Right now, there are two mutexes serializing r/w ops: one "generic"
> and another one specifically for stream on/off.
>
> Clean it a little bit, getting rid of one of the mutexes.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> index 43eb82884555..50553975c39d 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
> @@ -31,7 +31,6 @@ MODULE_PARM_DESC(disable_rc, "Disable inbuilt IR receiver.");
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
>  struct dvbsky_state {
> -       struct mutex stream_mutex;
>         u8 ibuf[DVBSKY_BUF_LEN];
>         u8 obuf[DVBSKY_BUF_LEN];
>         u8 last_lock;
> @@ -68,18 +67,17 @@ static int dvbsky_usb_generic_rw(struct dvb_usb_device *d,
>
>  static int dvbsky_stream_ctrl(struct dvb_usb_device *d, u8 onoff)
>  {
> -       struct dvbsky_state *state = d_to_priv(d);
>         int ret;
> -       u8 obuf_pre[3] = { 0x37, 0, 0 };
> -       u8 obuf_post[3] = { 0x36, 3, 0 };
> +       static u8 obuf_pre[3] = { 0x37, 0, 0 };
> +       static u8 obuf_post[3] = { 0x36, 3, 0 };
>
> -       mutex_lock(&state->stream_mutex);
> -       ret = dvbsky_usb_generic_rw(d, obuf_pre, 3, NULL, 0);
> +       mutex_lock(&d->usb_mutex);
> +       ret = dvb_usbv2_generic_rw_locked(d, obuf_pre, 3, NULL, 0);
>         if (!ret && onoff) {
>                 msleep(20);
> -               ret = dvbsky_usb_generic_rw(d, obuf_post, 3, NULL, 0);
> +               ret = dvb_usbv2_generic_rw_locked(d, obuf_post, 3, NULL, 0);
>         }
> -       mutex_unlock(&state->stream_mutex);
> +       mutex_unlock(&d->usb_mutex);
>         return ret;
>  }
>
> @@ -744,8 +742,6 @@ static int dvbsky_init(struct dvb_usb_device *d)
>         if (ret)
>                 return ret;
>         */
> -       mutex_init(&state->stream_mutex);
> -
>         state->last_lock = 0;
>
>         return 0;
>
>
>
> Thanks,
> Mauro

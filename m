Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43076 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab3APVkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 16:40:32 -0500
Received: by mail-oa0-f41.google.com with SMTP id k14so1982976oag.0
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 13:40:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130116172240.5d41da32@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<50F57519.5060402@iki.fi>
	<20130115151203.7221b1db@redhat.com>
	<50F5BE14.9000705@iki.fi>
	<CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
	<20130116115605.0fea6d03@redhat.com>
	<CAHFNz9KniYSbfoDHOw+=x3aA0eWqpiQd9LxgQEt3fjm1RwUc7g@mail.gmail.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<20130116172240.5d41da32@redhat.com>
Date: Thu, 17 Jan 2013 03:10:32 +0530
Message-ID: <CAHFNz9Lfy-zvM+Nr4P3hjfTfoM3hQatF1Lhm5dZuN5OT+ecwcA@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:52 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Wed, 16 Jan 2013 23:56:48 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> Consider this simple situation:
>> Your new API is using get_frontend and is polling the hardware, Now an
>> existing application is also doing monitoring of the statistics. So, now all
>> the decision box calculations are screwed.
>
> -EREADTHEFUCKINGPATCHES
>
> Patch 04/15:
>
> ...
> +static int mb86a20s_read_signal_strength_from_cache(struct dvb_frontend *fe,
> +                                                   u16 *strength)
> +{
> +       struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>
> +
> +       *strength = c->strength.stat[0].uvalue;
> +
> +       return 0;
>  }
> ...
>
> The returned value there is in the same range as before.
>
> Enough. If you don't read the patches, you're just making everybody
> loosing their time with your biased and incorrect comments.

-EFUCKEDUPMORON

The behaviour of the ioctls did change completely.

Manu

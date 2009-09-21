Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41251 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZIUEJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 00:09:55 -0400
Received: by bwz6 with SMTP id 6so1703389bwz.37
        for <linux-media@vger.kernel.org>; Sun, 20 Sep 2009 21:09:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253504805.3255.3.camel@pc07.localdom.local>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
Date: Mon, 21 Sep 2009 06:09:58 +0200
Message-ID: <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
Subject: Re: Bug in S2 API...
From: Markus Rechberger <mrechberger@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 5:46 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
>
> Am Montag, den 21.09.2009, 05:40 +0200 schrieb Markus Rechberger:
>> while porting the S2api to userspace I came accross the S2-API definition itself
>>
>> #define FE_SET_PROPERTY            _IOW('o', 82, struct dtv_properties)
>> #define FE_GET_PROPERTY            _IOR('o', 83, struct dtv_properties)
>>
>> while looking at this, FE_GET_PROPERTY should very likely be _IOWR
>>
>> in dvb-frontend.c:
>> ----
>>         if(cmd == FE_GET_PROPERTY) {
>>
>>                 tvps = (struct dtv_properties __user *)parg;
>>
>>                 dprintk("%s() properties.num = %d\n", __func__, tvps->num);
>>                 dprintk("%s() properties.props = %p\n", __func__, tvps->props);
>>                 ...
>>                 if (copy_from_user(tvp, tvps->props, tvps->num *
>> sizeof(struct dtv_property)))
>> ----
>>
>> Regards,
>> Markus
>
> Seems to be a big issue.
>
> Why you ever want to write to a get property?
>

to read out the API version for example.
tvps->num is also used in order to check the boundaries of the property array.

Markus

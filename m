Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1LIWMD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 17:12:03 -0500
Message-ID: <4EE287A9.3000502@redhat.com>
Date: Fri, 09 Dec 2011 20:11:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi>
In-Reply-To: <4EE25CB4.3000501@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 17:08, Antti Palosaari wrote:
> On 12/09/2011 08:58 PM, Mauro Carvalho Chehab wrote:
>> On 09-12-2011 16:26, Antti Palosaari wrote:
>>> On 12/09/2011 08:20 PM, Mauro Carvalho Chehab wrote:
>>>> The DRX-K doesn't change the delivery system at set_properties,
>>>> but do it at frontend init. This causes problems on programs like
>>>> w_scan that, by default, opens both frontends.
>>>>
>>>> Instead, explicitly set the format when set_parameters callback is
>>>> called.
>>>
>>> May I ask why you don't use mfe_shared flag instead?
>>
>> Tested with it. Works. It takes a little more time to switch, but the
>> solution will be cleaner. version 2 will follow.
>
> Yes, there is kind of loop timer which tries to take FE and swithing takes second or two
>because it waits FE is freed. I looked it when I did MFE and I did not understood why
>it was done like that.
>
> cxd2820r has earlier simple lock (inside of demod driver) that just
> returned error immediately when busy. It is a little bit mystery for
> me why mfe_shared has that kind of waiting mechanism.

Still, it doesn't make much sense, at least on w_scan, as the only thing that is
called with each adapter is FE_GET_INFO:


open("/dev/dvb/adapter0/frontend0", O_RDWR|O_NONBLOCK) = 3
ioctl(3, FE_GET_INFO, 0x635120)         = 0
write(2, "\t/dev/dvb/adapter0/frontend0 -> "..., 92	/dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": specified was DVB-T -> SEARCH NEXT ONE.
) = 92
close(3)                                = 0
open("/dev/dvb/adapter0/frontend1", O_RDWR|O_NONBLOCK) = 3
ioctl(3, FE_GET_INFO, 0x635120)         = 0
write(2, "\t/dev/dvb/adapter0/frontend1 -> "..., 52	/dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": ) = 52
write(2, "good :-)\n", 9good :-)
)               = 9
close(3)                                = 0

Still, the second open takes about 4 seconds to complete, _even_ with O_NONBLOCK.

There's something bad there, as it is violating POSIX.

>Could someone explain reason for that?

I dunno, but I think this needs to be fixed, at least when the frontend
is opened with O_NONBLOCK.

Regards,
Mauro.

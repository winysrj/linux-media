Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58083 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2HFUhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 16:37:43 -0400
Received: by wgbdr13 with SMTP id dr13so3157595wgb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 13:37:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF5F4C4.7080904@redhat.com>
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
	<1341497792-6066-3-git-send-email-mchehab@redhat.com>
	<4FF5AD40.3070707@iki.fi>
	<CAKJOob9KBQRHXWTrOM_=hmF5OSoovhPWY4aGCbhhsbLKTk5NgQ@mail.gmail.com>
	<4FF5F4C4.7080904@redhat.com>
Date: Tue, 7 Aug 2012 02:07:41 +0530
Message-ID: <CAHFNz9+zRw_Wgxk6u5oi0VxTFKG6QPufqtfPrzW8+qHYi7xVXA@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Bert Massop <bert.massop@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 6, 2012 at 1:40 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 05-07-2012 14:37, Bert Massop escreveu:
>> On Thu, Jul 5, 2012 at 5:05 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 07/05/2012 05:16 PM, Mauro Carvalho Chehab wrote:
>>>>
>>>> Implement API support to return AFC frequency shift, as this device
>>>> supports it. The only other driver that implements it is tda9887,
>>>> and the frequency there is reported in Hz. So, use Hz also for this
>>>> tuner.
>>>
>>>
>>> What is AFC and why it is needed?
>>>
>>
>> AFC is short for Automatic Frequency Control, by which a tuner
>> automatically fine-tunes the frequency for the best reception,
>> compensating for small offsets and oscillator frequency drift.
>> This is however done automatically on the tuner, so its configuration
>> is read-only. Aside from being a "nice to know" statistic, getting
>> hold of the AFC frequency shift does as far as I know not have any
>> practical uses related to properly operating the tuner.
>
> AFC might be useful on a few situations. For example, my CATV operator
> still broadcasts some channels in both analog and digital.


If you have really have hardware that does AFC "Automatic Frequency Control",
then you shouldn't be exposing this value to userspace. It should be
held in the
driver alone.

Technically, hardware that do not have AFC alone should expose this value to
userspace, so that applications can control the dumb piece of hardware, that
doesn't lock to Fc aka "Center frequency". All decent tuners do lock onto the
center of the step size in any given case, these days.

When the driver knows the offset, it needs to compute the offset and sum it
to the resultant, so that get_frequency() retrieves the recomputed value.


Manu

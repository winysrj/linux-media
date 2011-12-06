Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43436 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab1LFVDI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 16:03:08 -0500
Message-ID: <4EDE8306.6000901@iki.fi>
Date: Tue, 06 Dec 2011 23:03:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
	linux-media@vger.kernel.org,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: Re: [PATCH 2/2] [media] tm6000: Fix bad indentation.
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de> <1323178776-12305-2-git-send-email-thierry.reding@avionic-design.de> <4EDE1F99.6080200@iki.fi> <20111206141316.GB12258@avionic-0098.adnet.avionic-design.de> <4EDE81EB.80800@redhat.com>
In-Reply-To: <4EDE81EB.80800@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2011 10:58 PM, Mauro Carvalho Chehab wrote:
> On 06-12-2011 12:13, Thierry Reding wrote:
>> * Antti Palosaari wrote:
>>> That question is related to that kind of indentation generally, not
>>> only that patch.
>>>
>>> On 12/06/2011 03:39 PM, Thierry Reding wrote:
>>>> Function parameters on subsequent lines should never be aligned with
>>>> the
>>>> function name but rather be indented.
>>> [...]
>>>> usb_set_interface(dev->udev,
>>>> - dev->isoc_in.bInterfaceNumber,
>>>> - 0);
>>>> + dev->isoc_in.bInterfaceNumber, 0);
>>>
>>> Which kind of indentation should be used when function params are
>>> slitted to multiple lines?
>
> Documentation/CodingStyle currently says:
>
> Statements longer than 80 columns will be broken into sensible chunks,
> unless
> exceeding 80 columns significantly increases readability and does not hide
> information. Descendants are always substantially shorter than the
> parent and
> are placed substantially to the right. The same applies to function headers
> with a long argument list. However, never break user-visible strings
> such as
> printk messages, because that breaks the ability to grep for them.
>
> So, it should be: "substantially to the right" whatever this means.
>
>> I don't think this is documented anywhere and there are no hard rules
>> with
>> regard to this. I guess anything is fine as long as it is indented at
>> all.
>>
>>> In that case two tabs are used (related to function indentation).
>>> example:
>>> ret= function(param1,
>>> param2);
>>
>> I usually use that because it is my text editor's default.
>>
>>> Other generally used is only one tab (related to function indentation).
>>> example:
>>> ret= function(param1,
>>> param2);
>>
>> I think that's okay as well.
>
> One tab can hardly be interpreted as "substantially to the right".
>
>>
>>> And last generally used is multiple tabs + spaces until same
>>> location where first param is meet (related to function
>>> indentation). I see that bad since use of tabs, with only spaces I
>>> see it fine. And this many times leads situation param level are
>>> actually different whilst originally idea was to put those same
>>> level.
>>> example:
>>> ret= function(param1,
>>> param2);
>
> In practice, this is the most commonly used way, from what I noticed,
> not only
> at drivers/media. A good place to look for commonly used CodingStyle are
> the
> most used headers at include/linux. As far as I noticed, they all use this
> style.

Yes, but it is not correct according to CodingStyle if you use spaces 
even when mixing with tabs.

Correct seems to be intend it adding only tabs, as many as possible, 
still not to exceed 80 char line len limit.


>> Whether this works or not always depends on the tab-width. I think most
>> variations are okay here. Some people like to align them, other people
>> don't.
>
> Tab width is always 8, according with the CodingStyle:
>
> "Tabs are 8 characters, and thus indentations are also 8 characters."
>
> Regards,
> Mauro
>


-- 
http://palosaari.fi/

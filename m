Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:57588 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbBSSmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 13:42:05 -0500
Received: by mail-qg0-f45.google.com with SMTP id h3so8472293qgf.4
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 10:42:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E60BFD.6090409@iki.fi>
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
	<54E5B028.5080900@southpole.se>
	<CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
	<54E60378.6030604@iki.fi>
	<CAKv9HNZPLws9=dpigcVtL7zedWYRit=yK_dw9EkdzH2VD55qMQ@mail.gmail.com>
	<54E60BFD.6090409@iki.fi>
Date: Thu, 19 Feb 2015 20:42:04 +0200
Message-ID: <CAKv9HNaWqs5MAEAfKKGOeNLY_brUaj4DGrE_t9EK2JzBjhFREg@mail.gmail.com>
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 February 2015 at 18:14, Antti Palosaari <crope@iki.fi> wrote:
> On 02/19/2015 06:01 PM, Antti Seppälä wrote:
>>
>> On 19 February 2015 at 17:38, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 02/19/2015 12:21 PM, Antti Seppälä wrote:
>>>>
>>>> On 19 February 2015 at 11:43, Benjamin Larsson <benjamin@southpole.se>
>>>> wrote:
>>>>>
>>>>>
>>>>> On 2015-02-19 10:13, Antti Seppälä wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> It seems that currently the firmware download on the mn88472 is
>>>>>> somehow wrong for my Astrometa HD-901T2.
>>>>>>
>>>>>> Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2
>>>>>> makes the firmware download consistently succeed.
>>>>>>
>>>>>
>>>>>
>>>>> Hi, try adding the workaround patch I sent for this.
>>>>>
>>>>> [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer
>>>>> errors
>>>>>
>>>>> I now see that it hasn't been merged. But I have been running with this
>>>>> patch for a few months now without any major issues.
>>>>>
>>>>
>>>> The patch really did improve firmware loading. Weird...
>>>>
>>>> Even with it I still get occasional i2c errors from r820t:
>>>>
>>>> [   15.874402] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=0a
>>>> len=1:
>>>> da
>>>> [   81.455517] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
>>>> len=4: 69 74 e6 df
>>>> [   99.949702] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
>>>> len=4: 69 74 e6 df
>>>>
>>>> These errors seem to appear more often if I'm reading the signal
>>>> strength values using e.g. femon.
>>>
>>>
>>>
>>> Could you disable whole IR polling and test
>>> modprobe dvb_usb_v2 disable_rc_polling=1
>>>
>>> It is funny that *increasing* RC polling makes things better, though...
>>>
>>
>> Hi.
>>
>> I tried loading the driver with polling disabled and it fails completely:
>>
>> [ 5526.693563] mn88472 7-0018: downloading firmware from file
>> 'dvb-demod-mn88472-02.fw'
>> [ 5527.032209] mn88472 7-0018: firmware download failed=-32
>> [ 5527.033864] rtl2832 7-0010: i2c reg write failed -32
>> [ 5527.033874] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=05 len=1:
>> 83
>> [ 5527.036014] rtl2832 7-0010: i2c reg write failed -32
>>
>> I have no idea why the device behaves so counter-intuitively. Is there
>> maybe some sorf of internal power-save mode the device enters when
>> there is no i2c traffic for a while or something?
>
>
> IR polling does not use I2C but some own commands. Could you make more
> tests. Use rtl28xxu module parameter to disable IR and test. It will disable
> both IR interrupts and polling. Then make some tests with different IR
> polling intervals to see how it behaves.
>

Hi Antti.

I made some further tests for you. Here are the results:

dvb_usb_v2 disable_rc_polling=1: firmware download FAILED

dvb_usb_rtl28xxu disable_rc=1: firmware download FAILED

Then I restored the module parameters to default values and tested
with various rc->interval values:

interval = 800: firmware download FAILED
interval = 600: firmware download FAILED
interval = 400: firmware download FAILED
interval = 300: firmware download SUCCESS but I2C errors from tuner
could be sometimes observed
interval = 200: firmware download SUCCESS
interval = 100: firmware download SUCCESS

So somehow higher rc polling rate makes the firmware download succeed.
This could indeed be some locking/timing related bug.

Please let me know if there is something else I can test.

-Antti

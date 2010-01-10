Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:54596 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0AJU2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 15:28:34 -0500
Message-ID: <4B4A386D.3080106@freemail.hu>
Date: Sun, 10 Jan 2010 21:28:29 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_pac7302: sporatdic problem when plugging the device
References: <4B4A0752.6030306@freemail.hu> <20100110204844.770f8fd7@tele>
In-Reply-To: <20100110204844.770f8fd7@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 10 Jan 2010 17:58:58 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> Then I plugged and unplugged the device 16 times. When I last plugged
>> the device I get the following error in the dmesg:
>>
>> [32393.421313] gspca: probing 093a:2626
>> [32393.426193] gspca: video0 created
>> [32393.426958] gspca: probing 093a:2626
>> [32393.426968] gspca: Interface class 1 not handled here
>> [32394.005917] pac7302: reg_w_page(): Failed to write register to
>> index 0x49, value 0x0, error -71
>> [32394.067799] gspca: set alt 8 err -71
>> [32394.090792] gspca: set alt 8 err -71
>> [32394.118159] gspca: set alt 8 err -71
>>
>> The 17th plug was working correctly again. I executed this test on an
>> EeePC 901.
>>
>> This driver version contains the msleep(4) in the reg_w_buf().
>> However, here the reg_w_page() fails, which does not have msleep()
>> inside. I don't know what is the real problem, but I am afraid that
>> slowing down reg_w_page() would make the time longer when the device
>> can be used starting from the event when it is plugged.
> 
> Hi again,
> 
> I don't understand what you mean by:
>> This driver version contains the msleep(4) in the reg_w_buf().
>> However, here the reg_w_page() fails, which does not have msleep()
>> inside.
I tought that the msleep(4) call introduced recently fixed the plug-in
problem. It seems I misunderstood something.

> Indeed the delay will slow down the webcam start (256 * 4 ms = 1s).
> 
> If having a delay fixes the problem, then, as the error always occurs
> at the same index 0x49 (3 reports), a single delay could be set before
> writing to this index. Do you want I code this for test?

I tested the behaviour a little bit more. Out of 100 plug-ins:

OK: 81 times
"pac7302: reg_w_page(): Failed to write register to index 0x49, value 0x0, error -71": 19 times

Other error message I haven't got, so 19% of the time writing to register
index 0x49 fails in reg_w_page(). So let's try doing fixing the way you
described. If you send me a patch I can test it.

Regards,

	Márton Németh


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaKUKN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 05:13:59 -0500
Message-ID: <546F103D.6050004@redhat.com>
Date: Fri, 21 Nov 2014 11:13:17 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/9] rc: sunxi-cir: Add support for the larger fifo found
 on sun5i and sun6i
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com> <1416498928-1300-6-git-send-email-hdegoede@redhat.com> <20141120142856.16b6562d@recife.lan> <20141121082620.GJ24143@lukather> <546EFAE1.9050506@redhat.com> <20141121095934.GA4752@lukather>
In-Reply-To: <20141121095934.GA4752@lukather>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/21/2014 10:59 AM, Maxime Ripard wrote:
> On Fri, Nov 21, 2014 at 09:42:09AM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 11/21/2014 09:26 AM, Maxime Ripard wrote:
>>> Hi Mauro,
>>>
>>> On Thu, Nov 20, 2014 at 02:28:56PM -0200, Mauro Carvalho Chehab wrote:
>>>> Em Thu, 20 Nov 2014 16:55:24 +0100
>>>> Hans de Goede <hdegoede@redhat.com> escreveu:
>>>>
>>>>> Add support for the larger fifo found on sun5i and sun6i, having a separate
>>>>> compatible for the ir found on sun5i & sun6i also is useful if we ever want
>>>>> to add ir transmit support, because the sun5i & sun6i version do not have
>>>>> transmit support.
>>>>>
>>>>> Note this commits also adds checking for the end-of-packet interrupt flag
>>>>> (which was already enabled), as the fifo-data-available interrupt flag only
>>>>> gets set when the trigger-level is exceeded. So far we've been getting away
>>>>> with not doing this because of the low trigger-level, but this is something
>>>>> which we should have done since day one.
>>>>>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>
>>>> As this is meant to be merged via some other tree:
>>>>
>>>> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> I think merging it through your tree would be just fine.
>>>
>>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> Heh, I was thinking it would be best if it went through Maxime's tree because
>> it also has some deps on new clk stuff (well the dts have deps on that), but either
>> way works for me.
>>
>> Maxime if you want this go through Mauro's tree, I can send a pull-req to Mauro
>> (I'm a linux-media sub-maintainer), so if that is the case let me know and I'll
>> prepare a pull-req (after fixing the missing reset documentation in the bindings).
> 
> So much for not reading the cover letter... Sorry.
> 
> We're getting quite close to the end of the ARM merge window, and I
> got a couple comments, Lee hasn't commented yet, so I'd say it's a bit
> too late for this to come in.

Oh, but this was not intended for 3.19, this can wait till 3.20 from my pov,
sorry if that was not clear. I was assuming that the merge window was more
or less closed already, so that this going into 3.20 was expected.

Regrrds,

Hans

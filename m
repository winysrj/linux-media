Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61015 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbbASOYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 09:24:39 -0500
MIME-Version: 1.0
In-Reply-To: <54BD11DF.1020907@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-5-git-send-email-hdegoede@redhat.com> <CAGb2v65BW7NABQXK877DkMNqDdBeuZ55wQHFkTexbWACFC4zFA@mail.gmail.com>
 <54929552.8090707@redhat.com> <20141219181708.GQ4820@lukather>
 <54954D5B.2020904@redhat.com> <CAGb2v676uRnKRNbBLPvcW4oTVzjWnNbVUTtw=DLoDyr2vn3Dgw@mail.gmail.com>
 <54BD11DF.1020907@redhat.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 19 Jan 2015 22:24:13 +0800
Message-ID: <CAGb2v65rs5Oa92RRoyv09BcoW6MLm2ynCn6oDbHrDDwsQ_Rz1w@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 04/13] rc: sunxi-cir: Add support for an
 optional reset controller
To: Hans de Goede <hdegoede@redhat.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 19, 2015 at 10:17 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 19-01-15 15:10, Chen-Yu Tsai wrote:
>>
>> Hi,
>>
>> On Sat, Dec 20, 2014 at 6:20 PM, Hans de Goede <hdegoede@redhat.com>
>> wrote:
>>>
>>> Hi,
>>>
>>>
>>> On 19-12-14 19:17, Maxime Ripard wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>> On Thu, Dec 18, 2014 at 09:50:26AM +0100, Hans de Goede wrote:
>>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>> On 18-12-14 03:48, Chen-Yu Tsai wrote:
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On Thu, Dec 18, 2014 at 1:18 AM, Hans de Goede <hdegoede@redhat.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On sun6i the cir block is attached to the reset controller, add
>>>>>>> support
>>>>>>> for de-asserting the reset if a reset controller is specified in dt.
>>>>>>>
>>>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>>>> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>>>>>> ---
>>>>>>>    .../devicetree/bindings/media/sunxi-ir.txt         |  2 ++
>>>>>>>    drivers/media/rc/sunxi-cir.c                       | 25
>>>>>>> ++++++++++++++++++++--
>>>>>>>    2 files changed, 25 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>>>>> b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>>>>> index 23dd5ad..6b70b9b 100644
>>>>>>> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>>>>> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>>>>> @@ -10,6 +10,7 @@ Required properties:
>>>>>>>
>>>>>>>    Optional properties:
>>>>>>>    - linux,rc-map-name : Remote control map name.
>>>>>>> +- resets : phandle + reset specifier pair
>>>>>>
>>>>>>
>>>>>>
>>>>>> Should it be optional? Or should we use a sun6i compatible with
>>>>>> a mandatory reset phandle? I mean, the driver/hardware is not
>>>>>> going to work with the reset missing on sun6i.
>>>>>>
>>>>>> Seems we are doing it one way for some of our drivers, and
>>>>>> the other (optional) way for more generic ones, like USB.
>>>>>
>>>>>
>>>>>
>>>>> I do not believe that we should add a new compatible just because
>>>>> the reset line of a block is hooked up differently. It is the
>>>>> exact same ip-block. Only now the reset is not controlled
>>>>> through the apb-gate, but controlled separately.
>>>>
>>>>
>>>>
>>>> He has a point though. Your driver might very well probe nicely and
>>>> everything, but still wouldn't be functional at all because the reset
>>>> line wouldn't have been specified in the DT.
>>>
>>>
>>>
>>> Right, just like other drivers we've, see e.g.:
>>>
>>> Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
>>>
>>> Which is dealing with this in the same way.
>>>
>>>> The easiest way to deal with that would be in the bindings doc to
>>>> update it with a compatible for the A31, and mentionning that the
>>>> reset property is mandatory there.
>>>
>>>
>>>
>>> No the easiest way to deal with this is to expect people writing
>>> the dts to know what they are doing, just like we do for a lot
>>> of the other blocks in sun6i.
>>>
>>> Maybe put a generic note somewhere that sun6i has a reset controller,
>>> and that for all the blocks with optional resets property it should
>>> be considered mandatory on sun6i ?
>>>
>>> I'm sorry but I'm not going to make this change for the ir bindings
>>> given that we've the same situation in a lot of other places.
>>>
>>> Consistency is important. Moreover I believe that having a sun6i
>>> specific compatible string is just wrong, since it is the exact
>>> same hardware block as on sun5i, just with its reset line routed
>>> differently, just like e.g. the mmc controller, the uarts or the gmac
>>> all of which also do not have a sun6i specific compatible to enforce
>>> reset controller usage.
>>>
>>> Regards,
>>>
>>> Hans
>>>
>>>
>>>
>>>
>>>> Note that the code itself might not change at all though. I'd just
>>>> like to avoid any potential breaking of the DT bindings themselves. If
>>>> we further want to refine the code, we can do that however we want.
>>>>
>>>> I have a slight preference for a clean error if reset is missing, but
>>>> I won't get in the way just for that.
>>
>>
>> Seems this patch and the following patch were overlooked after the
>> discussion. Any chance we could get this in?
>
>
> I'm a linux/media sub-maintainer, so I've already send a pull-req for
> these 2 to the linux/media maintainer, iow this is taken care of :)

That's good to hear. I was going through the mainlining effort page,
and couldn't find these 2 in linux-next. I'll mark them as planned
for 3.20 then.


Chen-Yu

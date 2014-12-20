Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaLTKUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 05:20:48 -0500
Message-ID: <54954D5B.2020904@redhat.com>
Date: Sat, 20 Dec 2014 11:20:11 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Chen-Yu Tsai <wens@csie.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] [PATCH v2 04/13] rc: sunxi-cir: Add support for
 an optional reset controller
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com> <1418836704-15689-5-git-send-email-hdegoede@redhat.com> <CAGb2v65BW7NABQXK877DkMNqDdBeuZ55wQHFkTexbWACFC4zFA@mail.gmail.com> <54929552.8090707@redhat.com> <20141219181708.GQ4820@lukather>
In-Reply-To: <20141219181708.GQ4820@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 19-12-14 19:17, Maxime Ripard wrote:
> Hi,
>
> On Thu, Dec 18, 2014 at 09:50:26AM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 18-12-14 03:48, Chen-Yu Tsai wrote:
>>> Hi,
>>>
>>> On Thu, Dec 18, 2014 at 1:18 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>>>> On sun6i the cir block is attached to the reset controller, add support
>>>> for de-asserting the reset if a reset controller is specified in dt.
>>>>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>>> ---
>>>>   .../devicetree/bindings/media/sunxi-ir.txt         |  2 ++
>>>>   drivers/media/rc/sunxi-cir.c                       | 25 ++++++++++++++++++++--
>>>>   2 files changed, 25 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>> index 23dd5ad..6b70b9b 100644
>>>> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>>>> @@ -10,6 +10,7 @@ Required properties:
>>>>
>>>>   Optional properties:
>>>>   - linux,rc-map-name : Remote control map name.
>>>> +- resets : phandle + reset specifier pair
>>>
>>> Should it be optional? Or should we use a sun6i compatible with
>>> a mandatory reset phandle? I mean, the driver/hardware is not
>>> going to work with the reset missing on sun6i.
>>>
>>> Seems we are doing it one way for some of our drivers, and
>>> the other (optional) way for more generic ones, like USB.
>>
>> I do not believe that we should add a new compatible just because
>> the reset line of a block is hooked up differently. It is the
>> exact same ip-block. Only now the reset is not controlled
>> through the apb-gate, but controlled separately.
>
> He has a point though. Your driver might very well probe nicely and
> everything, but still wouldn't be functional at all because the reset
> line wouldn't have been specified in the DT.

Right, just like other drivers we've, see e.g.:

Documentation/devicetree/bindings/mmc/sunxi-mmc.txt

Which is dealing with this in the same way.

> The easiest way to deal with that would be in the bindings doc to
> update it with a compatible for the A31, and mentionning that the
> reset property is mandatory there.

No the easiest way to deal with this is to expect people writing
the dts to know what they are doing, just like we do for a lot
of the other blocks in sun6i.

Maybe put a generic note somewhere that sun6i has a reset controller,
and that for all the blocks with optional resets property it should
be considered mandatory on sun6i ?

I'm sorry but I'm not going to make this change for the ir bindings
given that we've the same situation in a lot of other places.

Consistency is important. Moreover I believe that having a sun6i
specific compatible string is just wrong, since it is the exact
same hardware block as on sun5i, just with its reset line routed
differently, just like e.g. the mmc controller, the uarts or the gmac
all of which also do not have a sun6i specific compatible to enforce
reset controller usage.

Regards,

Hans



> Note that the code itself might not change at all though. I'd just
> like to avoid any potential breaking of the DT bindings themselves. If
> we further want to refine the code, we can do that however we want.
>
> I have a slight preference for a clean error if reset is missing, but
> I won't get in the way just for that.
>
> Maxime
>

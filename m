Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaLRIvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:51:01 -0500
Message-ID: <54929552.8090707@redhat.com>
Date: Thu, 18 Dec 2014 09:50:26 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] [PATCH v2 04/13] rc: sunxi-cir: Add support for
 an optional reset controller
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com> <1418836704-15689-5-git-send-email-hdegoede@redhat.com> <CAGb2v65BW7NABQXK877DkMNqDdBeuZ55wQHFkTexbWACFC4zFA@mail.gmail.com>
In-Reply-To: <CAGb2v65BW7NABQXK877DkMNqDdBeuZ55wQHFkTexbWACFC4zFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 18-12-14 03:48, Chen-Yu Tsai wrote:
> Hi,
>
> On Thu, Dec 18, 2014 at 1:18 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> On sun6i the cir block is attached to the reset controller, add support
>> for de-asserting the reset if a reset controller is specified in dt.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>   .../devicetree/bindings/media/sunxi-ir.txt         |  2 ++
>>   drivers/media/rc/sunxi-cir.c                       | 25 ++++++++++++++++++++--
>>   2 files changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>> index 23dd5ad..6b70b9b 100644
>> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
>> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
>> @@ -10,6 +10,7 @@ Required properties:
>>
>>   Optional properties:
>>   - linux,rc-map-name : Remote control map name.
>> +- resets : phandle + reset specifier pair
>
> Should it be optional? Or should we use a sun6i compatible with
> a mandatory reset phandle? I mean, the driver/hardware is not
> going to work with the reset missing on sun6i.
>
> Seems we are doing it one way for some of our drivers, and
> the other (optional) way for more generic ones, like USB.

I do not believe that we should add a new compatible just because
the reset line of a block is hooked up differently. It is the
exact same ip-block. Only now the reset is not controlled
through the apb-gate, but controlled separately.

Regards,

Hans

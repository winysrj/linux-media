Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbAEJbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 04:31:36 -0500
Message-ID: <54AA59D9.7030909@redhat.com>
Date: Mon, 05 Jan 2015 10:31:05 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 12/13] ARM: dts: sun6i: Add sun6i-a31s.dtsi
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com> <1418836704-15689-13-git-send-email-hdegoede@redhat.com> <20141219183450.GZ4820@lukather> <54954E77.4070302@redhat.com> <20141221223941.GC4820@lukather> <549820A4.9090900@redhat.com> <20150105090825.GA31311@lukather>
In-Reply-To: <20150105090825.GA31311@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05-01-15 10:08, Maxime Ripard wrote:
> Hi,
>
> On Mon, Dec 22, 2014 at 02:46:12PM +0100, Hans de Goede wrote:
>> On 21-12-14 23:39, Maxime Ripard wrote:
>>> On Sat, Dec 20, 2014 at 11:24:55AM +0100, Hans de Goede wrote:

<snip>

>>>>> Given your previous changes, you should also update the enable-method.
>>>>
>>>> I've not added a new compatible for the enable-method, given that
>>>> this is the exact same die, so the 2 are 100?% compatible, just like you
>>>> insisted that "allwinner,sun4i-a10-mod0-clk" should be used for the ir-clk
>>>> since it was 100% compatible to that I believe that the enable method
>>>> should use the existing compatible and not invent a new one for something
>>>> which is 100% compatible.
>>>
>>> Yeah, you have a point and I agree, but your patch 3 does add a
>>> CPU_METHOD_OF_DECLARE for the A31s.
>>
>> Ah right, it does, my bad.
>>
>>> Since I was going to push the branch now that 3.19-rc1 is out, do you
>>> want me to edit your patch before doing so?
>>
>> Yes, please drop the addition of the extra CPU_METHOD_OF_DECLARE, or let
>> me know if you want a new version instead.
>
> I just modified it, and pushed it, no need to resend it.

Thanks, while looking at your dt-for-3.20 branch I noticed that you've
merged v2 of "ARM: dts: sun6i: Add ir node", I did a v3 adding an ir:
label to the node, which I noticed was missing because you asked me to
move the a31s dt stuff to moving label references, can you fix this up, or
do you want me to do a follow up patch ?

Note that having this fixed is a pre-req for the csq-cs908 dts patch.

Regards,

Hans

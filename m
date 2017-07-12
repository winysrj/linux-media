Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35248 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbdGLRMs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 13:12:48 -0400
Subject: Re: [PATCH v2] [media] staging/imx: remove confusing IS_ERR_OR_NULL
 usage
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20170711132001.2266388-1-arnd@arndb.de>
 <1499874605.6374.56.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0470fa74-dfbd-e512-295c-4ba64c483aac@gmail.com>
Date: Wed, 12 Jul 2017 10:12:45 -0700
MIME-Version: 1.0
In-Reply-To: <1499874605.6374.56.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/12/2017 08:50 AM, Philipp Zabel wrote:
> On Tue, 2017-07-11 at 15:18 +0200, Arnd Bergmann wrote:
>> While looking at a compiler warning, I noticed the use of
>> IS_ERR_OR_NULL, which is generally a sign of a bad API design
>> and should be avoided.
>>
>> In this driver, this is fairly easy, we can simply stop storing
>> error pointers in persistent structures, and change the two
>> functions that might return either a NULL pointer or an error
>> code to consistently return error pointers when failing.
>>
>> of_parse_subdev() now separates the error code and the pointer
>> it looks up, to clarify the interface. There are two cases
>> where this function originally returns 'NULL', and I have
>> changed that to '0' for success to keep the current behavior,
>> though returning an error would also make sense there.
>>
>> Fixes: e130291212df ("[media] media: Add i.MX media core driver")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> v2: fix type mismatch
>> v3: rework of_parse_subdev() as well.
> 
> Thanks!
> 
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> 

Looks fine to me. Tested on SabreAuto with affected pipelines.

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>

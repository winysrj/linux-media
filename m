Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38394 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbeBGPyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Feb 2018 10:54:25 -0500
Subject: Re: [PATCH 1/2] media: adv7604: Add support for
 i2c_new_secondary_device
To: Rob Herring <robh@kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
 <1516625389-6362-2-git-send-email-kieran.bingham@ideasonboard.com>
 <20180129200813.ifaz2bkkxshiodga@rob-hp-laptop>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <4ff04149-9726-716c-306c-819130897c98@ideasonboard.com>
Date: Wed, 7 Feb 2018 15:54:20 +0000
MIME-Version: 1.0
In-Reply-To: <20180129200813.ifaz2bkkxshiodga@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 29/01/18 20:08, Rob Herring wrote:
> On Mon, Jan 22, 2018 at 12:49:56PM +0000, Kieran Bingham wrote:
>> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>
>> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
>> I²C ports. Each map has it own I²C address and acts as a standard slave
>> device on the I²C bus.
>>
>> Allow a device tree node to override the default addresses so that
>> address conflicts with other devices on the same bus may be resolved at
>> the board description level.
>>
>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> [Kieran: Re-adapted for mainline]
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>> ---
>> Based upon the original posting :
>>   https://lkml.org/lkml/2014/10/22/469
>> ---
>>  .../devicetree/bindings/media/i2c/adv7604.txt      | 18 ++++++-
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Thank you.

> In the future, please split bindings to separate patch.

Yes, of course - sorry - I should probably have known better here.

I was clearly being lazy as the original patch had bindings in with the driver.
Although I don't think I've got an excuse for the second patch in the series :D

I've split them out for the v2.

--
Kieran

>>  drivers/media/i2c/adv7604.c                        | 60 ++++++++++++++--------
>>  2 files changed, 55 insertions(+), 23 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

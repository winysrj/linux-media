Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35746 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755173AbdEDN7a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 09:59:30 -0400
Received: by mail-yb0-f195.google.com with SMTP id 19so535717ybl.2
        for <linux-media@vger.kernel.org>; Thu, 04 May 2017 06:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMavjnA1XFooYrdtytrF6DHkZo9zc4Vn_4Qva4ZReUyUR7ESMw@mail.gmail.com>
References: <1491829376-14791-5-git-send-email-sakari.ailus@linux.intel.com>
 <1493121374-13298-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493905412.2381.20.camel@pengutronix.de> <CAMavjnA1XFooYrdtytrF6DHkZo9zc4Vn_4Qva4ZReUyUR7ESMw@mail.gmail.com>
From: Elizar Alcantara <jimbo@filsat.com>
Date: Thu, 4 May 2017 21:59:28 +0800
Message-ID: <CAMavjnDJF+YR9c6e7juBEr4_haCT9TSpfzRpX1LwCZuFtcD_bQ@mail.gmail.com>
Subject: Re: [PATCH v3.1 4/7] v4l: Switch from V4L2 OF not V4L2 fwnode API
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UNSUBSCRIBE linux-media@vger.kernel.org


On Thu, May 4, 2017 at 9:57 PM, Elizar Alcantara <jimbo@filsat.com> wrote:
> UNSUBSCRIBE
> linux-media@vger.kernel.org
>
>
>
>
>
> On Thu, May 4, 2017 at 9:43 PM, Philipp Zabel <p.zabel@pengutronix.de>
> wrote:
>>
>> On Tue, 2017-04-25 at 14:56 +0300, Sakari Ailus wrote:
>> > Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
>> > Async OF matching is replaced by fwnode matching and OF matching support
>> > is removed.
>> >
>> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> > Acked-by: Benoit Parrot <bparrot@ti.com> # i2c/ov2569.c,
>> > am437x/am437x-vpfe.c and ti-vpe/cal.c
>> > Tested-by: Hans Verkuil <hans.verkuil@cisco.com> # Atmel sama5d3 board +
>> > ov2640 sensor
>>
>> Tested and works on v4.11 with Steve's imx-media-staging-md branch on
>> Nitrogen6X i.MX6Q + Toshiba TC358743 HDMI to MIPI CSI-2 bridge.
>>
>> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> regards
>> Philipp
>>
>

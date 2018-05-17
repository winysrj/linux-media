Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35614 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeEQIsF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:48:05 -0400
Received: by mail-lf0-f66.google.com with SMTP id y72-v6so7567743lfd.2
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 01:48:04 -0700 (PDT)
Subject: Re: [PATCH 3/6] media: rcar-vin: Handle data-active property
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b86296ae-f12b-24ae-80ce-329b6486b928@cogentembedded.com>
Date: Thu, 17 May 2018 11:48:02 +0300
MIME-Version: 1.0
In-Reply-To: <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 5/16/2018 7:32 PM, Jacopo Mondi wrote:

> The data-active property has to be specified when running with embedded

    Prop names are typically enclosed in "".

> synchronization. The VIN peripheral can use HSYNC in place of CLOCKENB

    CLKENB, maybe?

> when the CLOCKENB pin is not connected, this requires explicit
> synchronization to be in use.
> 
> Now that the driver supports 'data-active' property, it makes not sense

    "data-active", s/not/no/.

> to zero the mbus configuration flags when running with implicit synch

    Sync is better. :-)

> (V4L2_MBUS_BT656).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
[...]

MBR, Sergei

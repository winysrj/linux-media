Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33945 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbeELJcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 05:32:06 -0400
Received: by mail-lf0-f44.google.com with SMTP id r25-v6so11253313lfd.1
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 02:32:06 -0700 (PDT)
Subject: Re: [PATCH 5/5] media: rcar-vin: Use FTEV for digital input
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-6-git-send-email-jacopo+renesas@jmondi.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b6dc7ab8-7995-8146-943d-702ce1800121@cogentembedded.com>
Date: Sat, 12 May 2018 12:32:00 +0300
MIME-Version: 1.0
In-Reply-To: <1526032781-14319-6-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 5/11/2018 12:59 PM, Jacopo Mondi wrote:

> Since commit (015060cb

    Need 12 digits here, and SHA1 ID should be cited outside the parens.

> "media: rcar-vin: enable field toggle after a set
> number of lines for Gen3)

    The commit summary must be enclosed in ("").
    And I think Niklas has posted the patches reverting that commit and fixing 
the driver properly.

> the VIN generates an internal field signal
> toggle after a fixed number of received lines, and uses the internal
> field signal to drive capture operations. When capturing from digital
> input, using FTEH driven field signal toggling messes up the received
> image sizes. Fall back to use FTEV driven signal toggling when capturing
> from digital input.
> 
> As explained in the comment, this disables buffer overflow protection
> for digital input capture, for which the FOE overflow might be used in
> future.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
[...]

MBR, Sergei

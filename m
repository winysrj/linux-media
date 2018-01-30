Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36113 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbeA3Q7C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 11:59:02 -0500
Date: Tue, 30 Jan 2018 10:59:01 -0600
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@iki.fi,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media: dt-bindings: Add OF properties to ov7670
Message-ID: <20180130165901.bx6myeeospv55tgo@rob-hp-laptop>
References: <1516786250-3750-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516786250-3750-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516786250-3750-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 24, 2018 at 10:30:49AM +0100, Jacopo Mondi wrote:
> Describe newly introduced OF properties for ov7670 image sensor.
> The driver supports two standard properties to configure synchronism
> signals polarities and one custom property already supported as
> platform data options to suppress pixel clock during horizontal
> blankings.
> 
> Re-phrase child nodes description while at there.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov7670.txt | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>

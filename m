Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:37826 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeJMUK2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 16:10:28 -0400
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
To: <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-5-vz@mleia.com> <20181012060314.GU4939@dell>
 <63733d2e-f95e-8894-f2b0-0b551b5cfeeb@mentor.com>
 <20181012083924.GW4939@dell>
 <eef99526-9232-8cd4-9a7c-c30114d58806@ideasonboard.com>
 <506c03d7-7986-44dd-3290-92d16a8106ad@mentor.com>
 <4a807a53-1592-a895-f140-54e7acc473b3@ideasonboard.com>
CC: Lee Jones <lee.jones@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <646af723-b78b-4481-50d9-e1b8f57abd79@mentor.com>
Date: Sat, 13 Oct 2018 15:33:21 +0300
MIME-Version: 1.0
In-Reply-To: <4a807a53-1592-a895-f140-54e7acc473b3@ideasonboard.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 10/12/2018 02:47 PM, Kieran Bingham wrote:
> Hi Vladimir,
> 

[snip]

> 
> Essentially they are multi purpose buses - which do not yet have a home.
> We have used media as a home because of our use case.
> 
> The use case whether they transfer frames from a camera or to a display
> are of course closely related, but ultimately covered by two separate
> subsystems at the pixel level (DRM vs V4L, or other for other data)
> 
> Perhaps as they are buses - on a level with USB or I2C (except they can
> of course carry I2C or Serial as well as 'bi-directional video' etc ),
> they are looking for their own subsystem.
> 
> Except I don't think we don't want to add a new subsystem for just one
> (or two) devices...
> 

I suppose that the incomplete list includes Maxim GMSL, TI FPD-Link III,
SMSC/Microchip MOST (drivers/staging/most -- what's the destination after
exiting staging?) an Inova APIX.

--
Best wishes,
Vladimir

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43492 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbeDPM0e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:26:34 -0400
Subject: Re: OV5640 with 12MHz xclk
To: Samuel Bobrowicz <sam@elite-embedded.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d87c28b-4adb-86d6-986b-e1ffdceb3138@xs4all.nl>
Date: Mon, 16 Apr 2018 14:26:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2018 03:39 AM, Samuel Bobrowicz wrote:
> Can anyone verify if the OV5640 driver works with input clocks other
> than the typical 24MHz? The driver suggests anything from 6MHz-24MHz
> is acceptable, but I am running into issues while bringing up a module
> that uses a 12MHz oscillator. I'd expect that different xclk's would
> necessitate different register settings for the various resolutions
> (PLL settings, PCLK width, etc.), however the driver does not seem to
> modify nearly enough based on the frequency of xclk.
> 
> Sam
> 

I'm pretty sure it has never been tested with 12 MHz. The i.MX SabreLite
seems to use 22 MHz, and I can't tell from the code what the SabreSD uses
(probably 22 or 24 MHz). Steve will probably know.

Regards,

	Hans

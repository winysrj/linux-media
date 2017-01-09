Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45542 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751599AbdAIO5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 09:57:14 -0500
Subject: Re: [RFC] [sur40] mapping of sensor parameters to V4L2?
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
References: <alpine.DEB.2.10.1701031346040.18874@butterbrot>
Cc: modin@yuri.at, benjamin.tissoires@redhat.com,
        hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <93af6f64-0cb0-bed7-8ff2-9c82b171b6b9@xs4all.nl>
Date: Mon, 9 Jan 2017 15:57:01 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1701031346040.18874@butterbrot>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 01:57 PM, Florian Echtler wrote:
> Hi everyone,
> 
> next chapter in the neverending story of reverse-engineering the SUR40:
> 
> I've identified a couple of internal LCD panel registers which control 
> some aspects of the built-in image sensor. In particular, these are called 
> "Video Voltage", "Video Bias", and "IR Illumination Level".
> 
> Now, I have two questions:
> 
> - Video Voltage & Bias seem to affect the sensor gain. Does anyone with 
> extensive background knowledge of image sensors want to venture a guess 
> what the exact relation is? My own interpretation would be that Video 
> Voltage is the actual amplifier gain and Video Bias is the black level...
> 
> - Is there a sensible mapping of these values to V4L2 controls? Should I 
> pick something from the USER class, or from CAMERA, or FLASH, or ...

I think it would be best to add a control class for touch device and add
these controls there.

It's pretty specific to such devices, so that would make sense.

Regards,

	Hans


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:34917 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754927AbeASKrj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 05:47:39 -0500
Subject: Re: [PATCH v6 6/9] media: i2c: ov772x: Remove soc_camera dependencies
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516139101-7835-7-git-send-email-jacopo+renesas@jmondi.org>
 <d67c21e5-2488-977b-39d8-561048409209@xs4all.nl>
Message-ID: <00f1dd19-6420-26ab-0529-a97f2b0de682@xs4all.nl>
Date: Fri, 19 Jan 2018 11:47:33 +0100
MIME-Version: 1.0
In-Reply-To: <d67c21e5-2488-977b-39d8-561048409209@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/18 11:24, Hans Verkuil wrote:
> On 01/16/18 22:44, Jacopo Mondi wrote:
>> Remove soc_camera framework dependencies from ov772x sensor driver.
>> - Handle clock and gpios
>> - Register async subdevice
>> - Remove soc_camera specific g/s_mbus_config operations
>> - Change image format colorspace from JPEG to SRGB as the two use the
>>   same colorspace information but JPEG makes assumptions on color
>>   components quantization that do not apply to the sensor
>> - Remove sizes crop from get_selection as driver can't scale
>> - Add kernel doc to driver interface header file
>> - Adjust build system
>>
>> This commit does not remove the original soc_camera based driver as long
>> as other platforms depends on soc_camera-based CEU driver.
>>
>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Un-acked.

I just noticed that this sensor driver has no enum_frame_interval and
g/s_parm support. How would a driver ever know the frame rate of the
sensor without that?

This looks like a bug to me.

Regards,

	Hans

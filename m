Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:59665 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761906AbdLSKlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:41:04 -0500
Subject: Re: [PATCH for 4.15] omapdrm/dss/hdmi4_cec: fix interrupt handling
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Henrik Austad <haustad@cisco.com>
References: <c8031caa-390c-7c13-aec3-59c56b10101b@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <361663c8-1232-d407-79f6-add81d478641@ti.com>
Date: Tue, 19 Dec 2017 12:40:19 +0200
MIME-Version: 1.0
In-Reply-To: <c8031caa-390c-7c13-aec3-59c56b10101b@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/17 15:32, Hans Verkuil wrote:
> The omap4 CEC hardware cannot tell a Nack from a Low Drive from an
> Arbitration Lost error, so just report a Nack, which is almost
> certainly the reason for the error anyway.
> 
> This also simplifies the implementation. The only three interrupts
> that need to be enabled are:
> 
> Transmit Buffer Full/Empty Change event: triggered when the
> transmit finished successfully and cleared the buffer.
> 
> Receiver FIFO Not Empty event: triggered when a message was received.
> 
> Frame Retransmit Count Exceeded event: triggered when a transmit
> failed repeatedly, usually due to the message being Nacked. Other
> reasons are possible (Low Drive, Arbitration Lost) but there is no
> way to know. If this happens the TX buffer needs to be cleared
> manually.
> 
> While testing various error conditions I noticed that the hardware
> can receive messages up to 18 bytes in total, which exceeds the legal
> maximum of 16. This could cause a buffer overflow, so we check for
> this and constrain the size to 16 bytes.
> 
> The old incorrect interrupt handler could cause the CEC framework to
> enter into a bad state because it mis-detected the "Start Bit Irregularity
> event" as an ARB_LOST transmit error when it actually is a receive error
> which should be ignored.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Henrik Austad <haustad@cisco.com>
> Tested-by: Henrik Austad <haustad@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 46 +++++++--------------------------
>   1 file changed, 9 insertions(+), 37 deletions(-)

Thanks, I have picked up this patch.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. 
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

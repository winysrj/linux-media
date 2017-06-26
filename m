Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55439 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdFZLGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 07:06:23 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v5 1/2] media: i2c: adv748x: add adv748x driver
To: Rob Herring <robh@kernel.org>, Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)"
        <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
References: <cover.90fc3153078e79a3f74af832de923ac675eb29ad.1497469745.git-series.kieran.bingham+renesas@ideasonboard.com>
 <de701d3899e68ddf8a2ad0316459b8f1868132b5.1497469745.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170622213401.jdktgcx5tbsxhh5d@rob-hp-laptop>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <dcc244f1-411b-886d-7d23-9aed3835da80@ideasonboard.com>
Date: Mon, 26 Jun 2017 12:06:15 +0100
MIME-Version: 1.0
In-Reply-To: <20170622213401.jdktgcx5tbsxhh5d@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Rob,

Comments addressed, and a new version 6 to be posted soon.

On 22/06/17 22:34, Rob Herring wrote:
> On Wed, Jun 14, 2017 at 08:58:12PM +0100, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Provide support for the ADV7481 and ADV7482.
>>
>> The driver is modelled with 4 subdevices to allow simultaneous streaming
>> from the AFE (Analog front end) and HDMI inputs though two CSI TX
>> entities.
>>
>> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
>> to the TXB CSI bus.
>>
>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>> and an earlier rework by Niklas Söderlund.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
...
>> +
>> +The digital output port nodes must contain at least one endpoint.
>> +
>> +Ports are optional if they are not connected to anything at the hardware level,
>> +but the driver may not provide any support for ports which are not described.
> 
> What the driver does is not relevant to the binding.

Of course. (Fixed)

> 
>> +
>> +Example:
>> +
>> +	video_receiver@70 {
> 
> video-receiver@70

Aha, I didn't realise the distinction between using '-' in node names and
properties vs '_' in labels.

Hopefully updated in my mind map. And I'll try to get this one right in the
future. :)

--
Regards

Kieran

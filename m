Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933729AbeEWUE7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 16:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <m3in7lrnl2.fsf@gmail.com>
References: <20180509143159.20690-1-rui.silva@linaro.org> <20180509143159.20690-2-rui.silva@linaro.org>
 <20180518141830.GA14547@rob-hp-laptop> <m3in7lrnl2.fsf@gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 23 May 2018 15:04:37 -0500
Message-ID: <CAL_JsqLRfwTT9Cr9rWJNdoKJoAWkD0eiaRhkqpa9d-t3Wbvbhg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] media: ov2680: dt: Add bindings for OV2680
To: Rui Miguel Silva <rmfrfs@gmail.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 10:27 AM, Rui Miguel Silva <rmfrfs@gmail.com> wrote:
> Hi Rob,
> On Fri 18 May 2018 at 14:18, Rob Herring wrote:
>>
>> On Wed, May 09, 2018 at 03:31:58PM +0100, Rui Miguel Silva wrote:
>>>
>>> Add device tree binding documentation for the OV2680 camera sensor.
>>>
>>> CC: devicetree@vger.kernel.org
>>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>>> ---
>>>  .../devicetree/bindings/media/i2c/ov2680.txt  | 46  +++++++++++++++++++
>>>  1 file changed, 46 insertions(+)
>>>  create mode 100644
>>> Documentation/devicetree/bindings/media/i2c/ov2680.txt
>>
>>
>> Please add acks/reviewed bys on new versions.
>
>
> I have add this to the cover letter [0]:
> - Removed Rob Herring Reviewed-by tag, since bindings have changed  since
> his
>  ack.
>
> But only now I notice that I did not CC the devicetree list for the all
> series, but only for this particular patch. Sorry about that.

NP. It's better to put this and revision history in the individual
patches. I don't always read cover letters anyways.

Rob

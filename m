Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdISUAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 16:00:37 -0400
MIME-Version: 1.0
In-Reply-To: <ef8edab3-5b55-c298-2a40-72b5e22586ea@linux.intel.com>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-21-sakari.ailus@linux.intel.com> <20170918210028.67sbpuetdh5j7wpf@rob-hp-laptop>
 <ef8edab3-5b55-c298-2a40-72b5e22586ea@linux.intel.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 19 Sep 2017 15:00:11 -0500
Message-ID: <CAL_Jsq+YKSDn7Hoq-2wRsGyGRbQvNPEVXrj13bSNCqQpKE2CvQ@mail.gmail.com>
Subject: Re: [PATCH v10 20/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        mika.westerberg@intel.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 18, 2017 at 4:56 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Rob,
>
>
> Rob Herring wrote:
>>
>> On Mon, Sep 11, 2017 at 11:00:04AM +0300, Sakari Ailus wrote:
>>>
>>> Document optional lens-focus and flash properties for the smiapp driver.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
>>>  1 file changed, 2 insertions(+)
>>
>>
>> Acked-by: Rob Herring <robh@kernel.org>
>
>
> Thanks for the ack. There have been since a few iterations of the set, and
> the corresponding patch in v13 has minor changes to this:

My review script can't deal with subject changes...

> <URL:http://www.spinics.net/lists/linux-media/msg121929.html>
>
> Essentially "flash" was renamed to "flash-leds" as the current flash devices
> we have are all LEDs and the referencing assumes LED framework's ways to
> describe LEDs. The same change is present in the patch adding the property

So we're kind of creating a binding that mirrors the gpio bindings
(*-gpios) which is a bit of an oddball as all other bindings have gone
with a fixed property name and then a *-names property to name them.
The main downside to this form is a prefixed property name is harder
to parse and validate. So perhaps we should follow the more common
pattern, but we're not really describing a h/w connection just an
association. And now we also have the trigger source binding to
associate LEDs with device nodes, so perhaps that should be used here.
We shouldn't really have 2 ways to associate things in DT even if how
that gets handled in the kernel is different.

Rob

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27210 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751548AbdIRV43 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 17:56:29 -0400
Subject: Re: [PATCH v10 20/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-21-sakari.ailus@linux.intel.com>
 <20170918210028.67sbpuetdh5j7wpf@rob-hp-laptop>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <ef8edab3-5b55-c298-2a40-72b5e22586ea@linux.intel.com>
Date: Tue, 19 Sep 2017 00:56:22 +0300
MIME-Version: 1.0
In-Reply-To: <20170918210028.67sbpuetdh5j7wpf@rob-hp-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Rob Herring wrote:
> On Mon, Sep 11, 2017 at 11:00:04AM +0300, Sakari Ailus wrote:
>> Document optional lens-focus and flash properties for the smiapp driver.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
>>  1 file changed, 2 insertions(+)
>
> Acked-by: Rob Herring <robh@kernel.org>

Thanks for the ack. There have been since a few iterations of the set, 
and the corresponding patch in v13 has minor changes to this:

<URL:http://www.spinics.net/lists/linux-media/msg121929.html>

Essentially "flash" was renamed to "flash-leds" as the current flash 
devices we have are all LEDs and the referencing assumes LED framework's 
ways to describe LEDs. The same change is present in the patch adding 
the property to video-interfaces.txt:

<URL:http://www.spinics.net/lists/linux-media/msg121924.html>

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com

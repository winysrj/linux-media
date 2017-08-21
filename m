Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33064 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753686AbdHUTEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 15:04:32 -0400
Subject: Re: [PATCH v2.1 2/3] leds: as3645a: Add LED flash class driver
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170819212410.3084-3-sakari.ailus@linux.intel.com>
 <20170819214226.20736-1-sakari.ailus@linux.intel.com>
 <fc6c7893-863b-53ff-48e3-d14297364e5d@gmail.com>
 <07392419-c586-a791-a994-bed39f73da94@iki.fi>
Cc: javier@dowhile0.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <cadbcd5b-ad5b-4c6c-8360-1f59aa2e5bf4@gmail.com>
Date: Mon, 21 Aug 2017 21:03:47 +0200
MIME-Version: 1.0
In-Reply-To: <07392419-c586-a791-a994-bed39f73da94@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/21/2017 03:53 PM, Sakari Ailus wrote:
> Hi Jacek,
> 
> Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the update.
>> I've noticed that you added node labels to the child device nodes
>> in [0]:
>>
>> "as3645a_flash : flash" and "as3645a_indicator : indicator"
> 
> The phandle references (as3645a_flash and as3645a_indicator) should
> actually be moved to the patch adding the flash property to the sensor
> device node. It doesn't do anything here, yet.
> 
>>
>> I am still seeing problems with this approach:
>>
>> 1) AFAIK these labels are only used for referencing nodes inside dts
>>    files and they don't affect the name property of struct device_node
> 
> That's right.
> 
>> 2) Even if you changed the node name from flash to as3645a_flash, you
>>    would get weird LED class device name "as3645a_flash:flash" in case
>>    label property is absent. Do you have any objections against the
>>    approach I proposed in the previous review?:
>>
>>
>>     snprintf(names->flash, sizeof(names->flash),
>> 	     AS_NAME":%s", node->name);
> 
> In the current patch, the device node of the flash controller is used,
> postfixed with colon and the name of the LED ("flash" or "indicator") if
> no label is defined. In other words, with that DT source you'll have
> "as3645a:flash" and "as3645a:indicator". So if you change the name of
> the device node of the I²C device, that will be reflected in the label.
> 
> If a label exists, then the label is used as such.
> 
> I don't really have objections to what you're proposing as such but my
> question is: is it useful? With that, the flash and indicator labels
> will not come from DT if label properties are undefined. They'll always
> be "as3645a:flash" and "as3645a:indicator", independently of the names
> of the device nodes.
> 

Ah, indeed, the node->name is put in place of devicename segment and
the node points to the LED controller node. Neat approach, likely to
be adopted as a pattern from now on for all new LED class drivers.


For the patch going through media tree:

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski

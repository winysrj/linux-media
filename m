Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:34162 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbdE2MjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 08:39:05 -0400
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
To: Sakari Ailus <sakari.ailus@iki.fi>, Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz, sebastian.reichel@collabora.co.uk
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
 <20170529122004.GE29527@valkosipuli.retiisi.org.uk>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <c7a98681-4c95-0103-96ee-97ca6a02d9b3@zonque.org>
Date: Mon, 29 May 2017 14:39:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170529122004.GE29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2017 02:20 PM, Sakari Ailus wrote:
> On Mon, May 08, 2017 at 12:24:18PM -0500, Rob Herring wrote:
>> On Fri, May 05, 2017 at 11:48:30AM +0300, Sakari Ailus wrote:
>>> Many camera sensor devices contain EEPROM chips that describe the
>>> properties of a given unit --- the data is specific to a given unit can
>>> thus is not stored e.g. in user space or the driver.
>>>
>>> Some sensors embed the EEPROM chip and it can be accessed through the
>>> sensor's I2C interface. This property is to be used for devices where the
>>> EEPROM chip is accessed through a different I2C address than the sensor.
>>
>> Different I2C address or bus? We already have i2c bindings for sub 
>> devices downstream of another I2C device. Either the upstream device 
>> passes thru the I2C transactions or itself is an I2C controller with a 
>> separate downstream bus. For those cases the EEPROM should be a child 
>> node. A phandle only makes sense if you have the sensor and eeprom 
>> connected to 2 entirely separate host buses.
> 
> Right. It's a different address but located in the same package with the
> module, just like the lens. I should have actually said "module", not the
> "sensor".
> 
> The EEPROM integration to the module is done by the module vendor, but it's
> entirely possible to have another module vendor to use the sensor but not
> add an EEPROM or use a different EEPROM. It is also possible that the EEPROM
> is on the same silicon with the sensor, then it's always guaranteed to be
> there.
> 
> The bottom line is still that a sensor is simply one of the component in a
> camera module; the rest of the module (lens, eeprom etc.) is not defined by
> the sensor, the parts are rather picked by the module vendor. Yet the sensor
> is a central piece in a module: it's always guaranteed to be there or it's
> not a camera module.

I agree, yes. I think the only way to solve this is to have a generic
EEPROM API that allows the camera sensor to read data from it. If
another vendor uses a different type of EEPROM, the sensor driver would
remain the same, as it only reads data from the storage behind the
phandle, not caring about the details.

Same goes for the lens driver, and after thinking about it for awhile,
I'd say it makes most sense to allow referencing a v4l2_subdev device
through a phandle from another v4l2_subdev, and then offload certain
commands such as V4L2_CID_FOCUS_ABSOLUTE to the device that does the
actual work. Opinions?


Thanks,
Daniel

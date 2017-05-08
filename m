Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33438 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755118AbdEHRYU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 13:24:20 -0400
Date: Mon, 8 May 2017 12:24:18 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 05, 2017 at 11:48:30AM +0300, Sakari Ailus wrote:
> Many camera sensor devices contain EEPROM chips that describe the
> properties of a given unit --- the data is specific to a given unit can
> thus is not stored e.g. in user space or the driver.
> 
> Some sensors embed the EEPROM chip and it can be accessed through the
> sensor's I2C interface. This property is to be used for devices where the
> EEPROM chip is accessed through a different I2C address than the sensor.

Different I2C address or bus? We already have i2c bindings for sub 
devices downstream of another I2C device. Either the upstream device 
passes thru the I2C transactions or itself is an I2C controller with a 
separate downstream bus. For those cases the EEPROM should be a child 
node. A phandle only makes sense if you have the sensor and eeprom 
connected to 2 entirely separate host buses.

Rob

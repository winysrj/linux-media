Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35842 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbdFROFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 10:05:55 -0400
Date: Sun, 18 Jun 2017 09:05:53 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        pavel@ucw.cz
Subject: Re: [PATCH 3/8] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170617003949.uq4qldmbzx227cj3@rob-hp-laptop>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497433639-13101-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 14, 2017 at 12:47:14PM +0300, Sakari Ailus wrote:
> Many camera sensor devices contain EEPROM chips that describe the
> properties of a given unit --- the data is specific to a given unit can
> thus is not stored e.g. in user space or the driver.
> 
> Some sensors embed the EEPROM chip and it can be accessed through the
> sensor's I2C interface. This property is to be used for devices where the
> EEPROM chip is accessed through a different I2C address than the sensor.
> 
> The intent is to later provide this information to the user space.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>

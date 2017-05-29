Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46410 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750925AbdE2MUK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 08:20:10 -0400
Date: Mon, 29 May 2017 15:20:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz, sebastian.reichel@collabora.co.uk, daniel@zonque.org
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170529122004.GE29527@valkosipuli.retiisi.org.uk>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Mon, May 08, 2017 at 12:24:18PM -0500, Rob Herring wrote:
> On Fri, May 05, 2017 at 11:48:30AM +0300, Sakari Ailus wrote:
> > Many camera sensor devices contain EEPROM chips that describe the
> > properties of a given unit --- the data is specific to a given unit can
> > thus is not stored e.g. in user space or the driver.
> > 
> > Some sensors embed the EEPROM chip and it can be accessed through the
> > sensor's I2C interface. This property is to be used for devices where the
> > EEPROM chip is accessed through a different I2C address than the sensor.
> 
> Different I2C address or bus? We already have i2c bindings for sub 
> devices downstream of another I2C device. Either the upstream device 
> passes thru the I2C transactions or itself is an I2C controller with a 
> separate downstream bus. For those cases the EEPROM should be a child 
> node. A phandle only makes sense if you have the sensor and eeprom 
> connected to 2 entirely separate host buses.

Right. It's a different address but located in the same package with the
module, just like the lens. I should have actually said "module", not the
"sensor".

The EEPROM integration to the module is done by the module vendor, but it's
entirely possible to have another module vendor to use the sensor but not
add an EEPROM or use a different EEPROM. It is also possible that the EEPROM
is on the same silicon with the sensor, then it's always guaranteed to be
there.

The bottom line is still that a sensor is simply one of the component in a
camera module; the rest of the module (lens, eeprom etc.) is not defined by
the sensor, the parts are rather picked by the module vendor. Yet the sensor
is a central piece in a module: it's always guaranteed to be there or it's
not a camera module.

Cc Daniel who was asking a related question.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

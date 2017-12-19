Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37402 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762519AbdLSMAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 07:00:23 -0500
Date: Tue, 19 Dec 2017 14:00:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kristian Beilke <beilke@posteo.de>
Cc: linux-media@vger.kernel.org, alan@linux.intel.com,
        andriy.shevchenko@linux.intel.com
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
Message-ID: <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc Alan and Andy.

On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
> Dear all,
> 
> I am trying to get the cameras in a Lenovo IdeaPad Miix 320 (Atom
> x5-Z8350 BayTrail) to work. The front camera is an ov2680. With kernel
> 4.14.4 and 4.15rc3 I see the following dmesg output:
> 
> 
> [   21.469907] ov2680: module is from the staging directory, the quality
>  is unknown, you have been warned.
> [   21.492774] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp module
> subdev data.PMIC ID 1
> [   21.492891] acpi OVTI2680:00: Failed to find gmin variable
> OVTI2680:00_CamClk
> [   21.492974] acpi OVTI2680:00: Failed to find gmin variable
> OVTI2680:00_ClkSrc
> [   21.493090] acpi OVTI2680:00: Failed to find gmin variable
> OVTI2680:00_CsiPort
> [   21.493209] acpi OVTI2680:00: Failed to find gmin variable
> OVTI2680:00_CsiLanes
> [   21.493511] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P8SX not
> found, using dummy regulator
> [   21.493550] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V2P8SX not
> found, using dummy regulator
> [   21.493569] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P2A not
> found, using dummy regulator
> [   21.493585] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply VPROG4B
> not found, using dummy regulator
> [   21.568134] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes: 1
> order: 00000002
> [   21.568257] ov2680 i2c-OVTI2680:00: read from offset 0x300a error -121
> [   21.568265] ov2680 i2c-OVTI2680:00: sensor_id_high = 0xffff
> [   21.568269] ov2680 i2c-OVTI2680:00: ov2680_detect err s_config.
> [   21.568291] ov2680 i2c-OVTI2680:00: sensor power-gating failed
> 
> Afterwards I do not get a camera device.
> 
> Am I missing some firmware or dependency? Can I somehow help to improve
> the driver?
> 
> Regards
> 
> Kristian
> 



-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

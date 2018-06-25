Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5381 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752711AbeFYICv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 04:02:51 -0400
Date: Mon, 25 Jun 2018 11:02:42 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: alanx.chiang@intel.com
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com,
        andriy.shevchenko@intel.com, rajmohan.mani@intel.com
Subject: Re: [RESEND PATCH v1 0/2] Add a property in at24.c
Message-ID: <20180625080242.ssbqnposyap6eok2@paasikivi.fi.intel.com>
References: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Mon, Jun 25, 2018 at 03:29:41PM +0800, alanx.chiang@intel.com wrote:
> From: "alanx.chiang" <alanx.chiang@intel.com>
> 
> In at24.c, it uses 8-bit addressing by default. In this patch,
> add a property address-width that provides a flexible method to
> pass the information to driver so that don't need to add the acpi
> or i2c ids for specific module.

Instead I'd point to the fact that other chip features have specific
properties while this one does not have one yet.

> 
> alanx.chiang (2):
>   eeprom: at24: Add support for address-width property
>   dt-bindings: at24: Add address-width property
> 
>  Documentation/devicetree/bindings/eeprom/at24.txt |  3 +++
>  drivers/misc/eeprom/at24.c                        | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
> 

A few notes:

- Please cc patches (or patchsets) touching DT bindings to the devicetree
  list <devicetree@vger.kernel.org>.

- Do also CC the maintainer (use scripts/get_maintainer.pl if unclear).

- Linux-media list is not the right list for I²C EEPROM driver patches ---
  please send the patches to linux-i2c@vger.kernel.org instead.

- You generally need to obtain the reviewed-by (or acked-by) tags from
  reviewers explicitly. You can't just add them based on people commenting
  on your patches.

- DT binding patches precede driver changes.

Please send v2 with these addressed.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:52139 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752991AbdHWBWj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 21:22:39 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 0/3] DW9714 DT support
Date: Wed, 23 Aug 2017 01:22:38 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5972FA7293@FMSMSX114.amr.corp.intel.com>
References: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patches.

I have verified that the dw9714 driver gets probed via DT bindings, with these patches on 4.13-rc6 kernel.

Feel free to add

Tested-by: Rajmohan Mani <rajmohan.mani@intel.com>

Raj

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Thursday, August 17, 2017 6:43 AM
> To: linux-media@vger.kernel.org
> Cc: devicetree@vger.kernel.org; Mani, Rajmohan
> <rajmohan.mani@intel.com>
> Subject: [PATCH 0/3] DW9714 DT support
> 
> Hi all,
> 
> This patchset adds DT bindings as well as DT support for DW9714. The unused
> ACPI match table is removed.
> 
> Sakari Ailus (3):
>   dt-bindings: Add bindings for Dongwoon DW9714 voice coil
>   dw9714: Add Devicetree support
>   dw9714: Remove ACPI match tables, convert to use probe_new
> 
>  .../bindings/media/i2c/dongwoon,dw9714.txt         |  9 ++++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  drivers/media/i2c/dw9714.c                         | 26 +++++++++-------------
>  3 files changed, 21 insertions(+), 15 deletions(-)  create mode 100644
> Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt
> 
> --
> 2.7.4

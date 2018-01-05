Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:11426 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751100AbeAEBW4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 20:22:56 -0500
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [RESEND PATCH 0/2] dw9714 fixes, cleanups
Date: Fri, 5 Jan 2018 01:22:54 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5972FEE2E3@FMSMSX114.amr.corp.intel.com>
References: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patches.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Tuesday, January 02, 2018 3:12 AM
> To: linux-media@vger.kernel.org
> Cc: Mani, Rajmohan <rajmohan.mani@intel.com>
> Subject: [RESEND PATCH 0/2] dw9714 fixes, cleanups
> 
> Hi,
> 
> (Fixed Raj's e-mail.)
> 
> The two patches address a small bug in dw9714 driver and clean it up a little,
> too.
> 
> Raj: could you let me know if they work for you? Thanks.
> 

These patches work fine.

> 
> Sakari Ailus (2):
>   dw9714: Call pm_runtime_idle() at the end of probe()
>   dw9714: Remove client field in driver's struct
> 
>  drivers/media/i2c/dw9714.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> --
> 2.7.4

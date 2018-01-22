Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22297 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbeAVVYe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 16:24:34 -0500
Date: Mon, 22 Jan 2018 23:24:29 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] imx258: Fix sparse warnings
Message-ID: <20180122212428.5e4joc27ld5anmoe@kekkonen.localdomain>
References: <8E0971CCB6EA9D41AF58191A2D3978B61D4E66C1@PGSMSX111.gar.corp.intel.com>
 <1516609961-26006-1-git-send-email-sakari.ailus@linux.intel.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4E699C@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D4E699C@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, Jan 22, 2018 at 03:19:00PM +0000, Yeh, Andy wrote:
> Hi Sakari,
> 
> I made a minor fix. I2C write function works after the change.  Please kindly review soon then I would submit v5. 
> 
> 	*buf++ = reg >> 8;
> 	*buf++ = reg & 0xff;
> 
> -	for (i = len - 1; i >= 0; i++)
> +	for (i = len - 1; i >= 0; i--)

Oops... it was untested all along. Thanks! I'll send v3.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

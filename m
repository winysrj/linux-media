Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:15975 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbeDWUcX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 16:32:23 -0400
Date: Mon, 23 Apr 2018 23:32:20 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yong Zhi <yong.zhi@intel.com>
Subject: Re: [PATCH 4/7] media: ipu3: allow building it with COMPILE_TEST on
 non-x86 archs
Message-ID: <20180423203220.oikwdaucdpf36luc@kekkonen.localdomain>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <07d3ab8b8c86a41488d22410968bec96714792f4.1524245455.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d3ab8b8c86a41488d22410968bec96714792f4.1524245455.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 01:42:50PM -0400, Mauro Carvalho Chehab wrote:
> Despite depending on ACPI, this driver builds fine on non-x86
> archtecture with COMPILE_TEST, as it doesn't depend on
> ACPI-specific functions/structs.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Feel free to take this through your tree.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com

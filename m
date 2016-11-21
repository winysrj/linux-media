Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25262 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754619AbcKUNv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 08:51:59 -0500
Subject: Re: [PATCH 1/1] v4l: videodev2: Include linux/time.h for timeval and
 timespec structs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <1477565451-3621-1-git-send-email-sakari.ailus@linux.intel.com>
 <20161121113311.0ec196f7@vento.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <5832FBFC.6070004@linux.intel.com>
Date: Mon, 21 Nov 2016 15:51:56 +0200
MIME-Version: 1.0
In-Reply-To: <20161121113311.0ec196f7@vento.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 11/21/16 15:33, Mauro Carvalho Chehab wrote:
> Em Thu, 27 Oct 2016 13:50:51 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> struct timeval and struct timespec are defined in linux/time.h. Explicitly
>> include the header if __KERNEL__ is defined.
> 
> The patch below doesn't do what you're mentioned above. It unconditionally
> include linux/time.h, and, for userspace, it will *also* include
> sys/time.h...

My bad... I thought writing a single line patch would be easy. ;-) Will fix.

> 
> I suspect that this would cause problems on userspace.
> 
> Btw, you didn't mention on your description what's the bug you're
> trying to fix.

The problem is a compiler error due to lacking defition for a struct.
I'll add that to v2.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com

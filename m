Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2151 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbeA2M0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 07:26:31 -0500
Message-ID: <1517228788.7000.1298.camel@linux.intel.com>
Subject: Re: [PATCH v2] staging: media: remove remains of
 VIDEO_ATOMISP_OV8858
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Corentin Labbe <clabbe@baylibre.com>, gregkh@linuxfoundation.org,
        mchehab@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date: Mon, 29 Jan 2018 14:26:28 +0200
In-Reply-To: <1517228167-1157-1-git-send-email-clabbe@baylibre.com>
References: <1517228167-1157-1-git-send-email-clabbe@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-01-29 at 12:16 +0000, Corentin Labbe wrote:
> OV8858 files are left unusable since commit 3a81c7660f80 ("media:
> staging: atomisp: Remove IMX sensor support")
> They are uncompilable since they depends on dw9718.c and vcm.c which
> was removed.
> 
> Remove the OV8858 kconfig and files.

Fine with me. We can sort things out later (repository will have the
sources still in any case) when the driver itself shows signs of life.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

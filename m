Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:36157 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdL1Tkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 14:40:39 -0500
Message-ID: <1514489766.7000.466.camel@linux.intel.com>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 28 Dec 2017 21:36:06 +0200
In-Reply-To: <1514489471.7000.463.camel@linux.intel.com>
References: <1514481444.7000.451.camel@intel.com>
         <alpine.DEB.2.20.1712281820040.1899@nanos>
         <1514482448.7000.460.camel@linux.intel.com>
         <alpine.DEB.2.20.1712281834520.1899@nanos>
         <1514489471.7000.463.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-28 at 21:31 +0200, Andy Shevchenko wrote:

> Anything I missed?

Perhaps I could bisect, though it's not so trivial in this case, when I
have a little more time. I guess it might take up to ~16 steps. If you
can point to more narrow range, it would be great.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

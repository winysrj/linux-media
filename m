Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:1977 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdITTbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:31:06 -0400
Message-ID: <1505935766.16112.24.camel@linux.intel.com>
Subject: Re: [PATCH] [media] staging: atomisp: use clock framework for
 camera clocks
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Sep 2017 22:29:26 +0300
In-Reply-To: <a547a897-37e9-1509-889e-d83ff055b3e4@linux.intel.com>
References: <20170919204549.27468-1-pierre-louis.bossart@linux.intel.com>
         <1505898738.16112.3.camel@linux.intel.com>
         <a547a897-37e9-1509-889e-d83ff055b3e4@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-09-20 at 12:01 -0500, Pierre-Louis Bossart wrote:
> 
> On 09/20/2017 04:12 AM, Andy Shevchenko wrote:
> > On Tue, 2017-09-19 at 15:45 -0500, Pierre-Louis Bossart wrote:
> > > The Atom ISP driver initializes and configures PMC clocks which
> > > are
> > > already handled by the clock framework.
> > > 
> > > Remove all legacy vlv2_platform_clock stuff and move to the clk
> > > API to
> > > avoid conflicts, e.g. with audio machine drivers enabling the MCLK
> > > for
> > > external codecs
> > > 
> > 
> > I think it might have a Fixes: tag as well (though I dunno which
> > commit
> > could be considered as anchor).
> 
> The initial integration of the atomisp driver already had this
> problem, 
> i'll add a reference to
> 'a49d25364dfb9 ("staging/atomisp: Add support for the Intel IPU v2")'

...which seems to be the best choice (you can check how many new commits
use that one as an origin for Fixes: tag).

> > 
> > (I doubt Git is so clever to remove files based on information out
> > of
> > the diff, can you check it and if needed to resend without -D
> > implied?)
> 
> Gee, I thought -C -M -D were the standard options to checkpatch,
> never 
> realized it'd prevent patches from applying. Thanks for the tip.

-C -M — yes for sure.

Last time I checked patches, generated with help of -D, do not remove
the files when you do git am. So, I don't know if it still the case.
Safe option is to use -C -M for public (+ -D locally only to see less
noise).

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

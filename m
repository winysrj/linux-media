Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37072 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751954AbeEGKSt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 06:18:49 -0400
Date: Mon, 7 May 2018 13:18:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] [media] omap3isp: support 64-bit version of
 omap3isp_stat_data
Message-ID: <20180507101846.vmn4yqqu7i3iybcd@valkosipuli.retiisi.org.uk>
References: <20180425213044.1535393-1-arnd@arndb.de>
 <20180503125627.6elsr4iiknnv227c@valkosipuli.retiisi.org.uk>
 <CAK8P3a0M5iKCXmKwQAzd9EKWo7Sr_0OR82Q=ozmj3f3Xtyde6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0M5iKCXmKwQAzd9EKWo7Sr_0OR82Q=ozmj3f3Xtyde6A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 03, 2018 at 06:06:58PM -0400, Arnd Bergmann wrote:
> On Thu, May 3, 2018 at 8:56 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Wed, Apr 25, 2018 at 11:30:10PM +0200, Arnd Bergmann wrote:
> >> @@ -165,7 +167,14 @@ struct omap3isp_h3a_aewb_config {
> >>   * @config_counter: Number of the configuration associated with the data.
> >>   */
> >>  struct omap3isp_stat_data {
> >> +#ifdef __KERNEL__
> >> +     struct {
> >> +             __s64   tv_sec;
> >> +             __s64   tv_usec;
> >
> > Any particular reason for __s64 here instead of e.g. long or __s32? Kernel
> > appears to use long in the timespec64 definition.
> 
> The user space 'timeval' definition is 16 bytes wide, with the layout
> designed to be compatible between 32-bit and 64-bit, so it has to be like
> this to match what user spaces sees with the old header files and a new
> libc.
> 
> We don't yet know what the exact definition of timeval will be in all
> libc implementations, but if they have a 32-bit tv_user field, it needs

tv_usec?

> padding next to it so the lower 32 bits are in the same place as they
> would be using that 64-bit field I used.

I presume the definition would be endianness dependent then. I have no
objections though, if you think this is the way to go.

I'll apply the patch.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

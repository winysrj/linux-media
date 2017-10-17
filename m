Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42140 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934122AbdJQPjE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 11:39:04 -0400
Date: Tue, 17 Oct 2017 18:39:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/atomisp: Convert timers to use timer_setup()
Message-ID: <20171017153900.ggh4pyaufyj5kz2l@valkosipuli.retiisi.org.uk>
References: <20171016232456.GA100862@beast>
 <20171017082307.qsupictqciku73jj@valkosipuli.retiisi.org.uk>
 <CAGXu5j+TN6rfM1t8qSO7b_5n+65MHAXsf8kZYRMyiq+2Orz+SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+TN6rfM1t8qSO7b_5n+65MHAXsf8kZYRMyiq+2Orz+SQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 17, 2017 at 08:16:03AM -0700, Kees Cook wrote:
> On Tue, Oct 17, 2017 at 1:23 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Mon, Oct 16, 2017 at 04:24:56PM -0700, Kees Cook wrote:
> >> In preparation for unconditionally passing the struct timer_list pointer to
> >> all timer callbacks, switch to using the new timer_setup() and from_timer()
> >> to pass the timer pointer explicitly.
> >>
> >> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Alan Cox <alan@linux.intel.com>
> >> Cc: Daeseok Youn <daeseok.youn@gmail.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: devel@driverdev.osuosl.org
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > This appears to be the same as the patch I've applied previously.
> 
> Okay, sorry for the noise. I didn't see it in -next when I did my
> rebase this week.

No worries, it'll get there through mediatree... but it'll still take some
time (rc3 not there yet).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

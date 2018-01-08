Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:34042 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756529AbeAHO1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 09:27:02 -0500
Date: Mon, 8 Jan 2018 14:26:39 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2] media: staging: atomisp: cleanup whitespaces
Message-ID: <20180108142639.5ac53fe1@alans-desktop>
In-Reply-To: <20180108142121.wsinvtmhngokhpp7@paasikivi.fi.intel.com>
References: <96780202f1f7ffe13f6e0426394c8c93a2cbaa77.1515091119.git.mchehab@s-opensource.com>
        <ab42c265e347855bb95809ef03e043653ab84a21.1515091119.git.mchehab@s-opensource.com>
        <20180108142121.wsinvtmhngokhpp7@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jan 2018 16:21:21 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> Hi Mauro,
> 
> On Thu, Jan 04, 2018 at 02:44:41PM -0500, Mauro Carvalho Chehab wrote:
> > There are lots of bad whitespaces at atomisp driver.
> > 
> > Fix them.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> > 
> > Sakari/Alan,
> > 
> > This is a script-generated patch that can be re-generated anytime.
> > If you prefer to not touch on it now, i'm perfectly fine.
> > 
> > I'm sending it just as completeness, as I'm doing a similar
> > cleanup under drivers/media, where  a number of <TAB><SPACE>
> > sequences accumulated over the time.   
> 
> Thanks for the patch.
> 
> In principle this is a worthwhile patch; I'd postpone it for the time being
> though: I understand that a few people are bisecting and / or applying
> out-of-tree patches to the driver to debug it on a few different hardware
> platforms. Let's wait until that work is done, and then apply this.

Given the kind of debug going on and the amount of time it's taking (plus
AtomISP for reasons people now know got mostly dropped from my work queue
since June) I'm happy if they get applied.

Can we apply the core ISP2401 merge from Vincent first though ?

Alan

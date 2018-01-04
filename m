Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:48941 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbeADRtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 12:49:23 -0500
Message-ID: <1515088070.7000.703.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Kristian Beilke <beilke@posteo.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Date: Thu, 04 Jan 2018 19:47:50 +0200
In-Reply-To: <20180102183106.79701c0f@alans-desktop>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
         <1513866211.7000.250.camel@linux.intel.com>
         <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
         <1514476996.7000.437.camel@linux.intel.com>
         <5fbb0600-82a0-5d17-a812-81d7707a335b@posteo.de>
         <CAHp75VftepWFT55Lwt-ki4K1+-Dy0y-=SU+bQQ6SRqkvapPF-w@mail.gmail.com>
         <20180102183106.79701c0f@alans-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-01-02 at 18:31 +0000, Alan Cox wrote:
> > Patch 0003-atomisp_gmin_platform-tweak-to-drive-axp288.patch gives a
> > little confusion.
> > The PMIC driver should work via ACPI OpRegion macro (and should be
> > enabled in kernel configuration). That's how it supposed to work.
> > The patch seems redundant.
> 
> I am fairly sure it is meant to work that way - but it doesn't. At
> least
> not at the moment.

Hmm... At least I see writes to PMIC on my side through OpRegion driver.

(Assuming my ugly hack patches applied)

> > > I see your point, Still it feels, as if this could go somewhere.  
> > 
> > I hope so, though I didn't try CherryTrail and according to Alan
> > that
> > is what he had tried on.
> 
> It's what we are currently trying on. I can fire up the ISP and
> actually
> get interrupts from it, but not much more at this point.

Seems you are ahead of everyone who is trying AtomISP till now.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

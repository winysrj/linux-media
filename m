Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33444 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750941AbdIIVhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 17:37:03 -0400
Date: Sun, 10 Sep 2017 00:36:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 18/24] as3645a: Switch to fwnode property API
Message-ID: <20170909213658.6hqbsn66q4xc2sex@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-14-sakari.ailus@linux.intel.com>
 <f6c79aff-dcc7-ee7d-e224-1f9bc6af1fee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6c79aff-dcc7-ee7d-e224-1f9bc6af1fee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Sat, Sep 09, 2017 at 09:06:41PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> I've come across this patch only by a chance. I believe that merging
> leds-as3645a.c patches via media tree is not going to be a persistent
> pattern. At least we haven't agreed on that, and in any case I should
> have a possibility to give my ack for this patch.

Correct. The reason the previous patches went through linux-media was
because these patches dependend on other patches only in linux-media at the
time. This is no longer the case (the three as3645a patches I'd like to get
in as fixes are another matter but let's discuss that separately).

> 
> Would you mind also adding linux-leds list on cc when touching areas
> related to LED/flash devices?

I added this patch to this version of the set and missed cc'ing it to
linux-leds. I think I'll send it there separately once the 17th patch (ACPI
support) has been reviewed. The two are loosely related to the rest of the
patches in the set but there's no hard dependency.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

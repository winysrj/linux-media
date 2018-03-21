Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38538 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbeCUR3v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 13:29:51 -0400
Received: by mail-wm0-f68.google.com with SMTP id l16so11337116wmh.3
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 10:29:51 -0700 (PDT)
Date: Wed, 21 Mar 2018 18:29:48 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: Re: [PATCH 0/5] SPDX license identifiers in all DD drivers
Message-ID: <20180321182948.6bcc0542@perian.wuest.de>
In-Reply-To: <20180321094932.GC16947@kroah.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
        <20180321094932.GC16947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

Am Wed, 21 Mar 2018 10:49:32 +0100
schrieb Greg KH <gregkh@linuxfoundation.org>:

> On Tue, Mar 20, 2018 at 10:01:27PM +0100, Daniel Scheller wrote:
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > This series adds SPDX license identifiers to all source files which are
> > copyright by either Digital Devices GmbH or Metzlerbros GbR, who are
> > the original authors of the ddbridge, ngene, cxd2099, mxl5xx, stv0910
> > and stv6111 bridge/demod/tuner drivers, with the mxl5xx driver being
> > based on source code released by MaxLinear.
> > [...]
> > The original intention was to fully replace all the licensing headers
> > with only the SPDX License Identifiers as it is done in a lot of other
> > in-tree drivers nowadays. However, Digital Devices disagreed to do this
> > and expressed major concerns regarding this, in that a machine readable
> > license tag instead of a full license boilerplate won't hold up equally,
> > so we agreed to keep the license boilerplate text as is right now.  
> 
> That's really odd, who at that company can I talk to about this?  Or
> really, what lawyer at that company can I point my lawyer at to talk
> about this, that's the only way this is going to get resolved.

I'm not entirely sure, but I guess for a first start it's best to
contact Ralph (from Metzlerbros) and Manfred (from Digital
Devices), being the authors and copyright owners of the DDDVB driver
package where the drivers originate from and thus is the upstream for
the mainlined copies of the mentioned drivers. Both are in the Cc list
(rjkm and mvoelkel) of this thread.

> If it helps, _ALL_ of the major companies that are kernel developers are
> onboard with the removal of the crazy boiler-plate text, so this tiny
> holdout should be easy to resolve.
> 
> > Greg, I'm Cc'ing you on this due to the last paragraph, as AFAIK you're
> > one of the initiators of the SPDX tagging initiative, and you even added
> > tags to 10k+ files all over the tree :-) so we maybe can discuss this
> > further, also with DD, in the hopes you're fine with this - sorry in
> > advance if not.  
> 
> See my review of your first patch here, this needs to be done a lot
> differently...

Check. Thanks for reviewing. The intent was to do a full cleanup of all
licensing things in one go, per driver. Will do one patch for SPDX and
eventual boilerplate cleanup for all drivers, one for MODULE_LICENSE
and one for missing headers in the next iteration. Though I'd wait
with that for now if you like to contact Ralph and Manfred, and do a v2
based on the outcome.

Thanks & best regards,
Daniel Scheller
-- 
https://github.com/herrnst

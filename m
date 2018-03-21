Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44418 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeCUJtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 05:49:35 -0400
Date: Wed, 21 Mar 2018 10:49:32 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: Re: [PATCH 0/5] SPDX license identifiers in all DD drivers
Message-ID: <20180321094932.GC16947@kroah.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2018 at 10:01:27PM +0100, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> This series adds SPDX license identifiers to all source files which are
> copyright by either Digital Devices GmbH or Metzlerbros GbR, who are
> the original authors of the ddbridge, ngene, cxd2099, mxl5xx, stv0910
> and stv6111 bridge/demod/tuner drivers, with the mxl5xx driver being
> based on source code released by MaxLinear.
> 
> All source code either carries the license text "redistribute and/or
> modify it under the terms of the GNU GPL version 2 only as published
> by the FSF", or simply "... GPL version 2" in the case of the mxl5xx
> driver, which all should equal to the SPDX License Identifier
> "GPL-2.0-only" as of SPDX License List Version 3.0 published on
> December the 28th, 2017, which is applied as license tag to all files
> of the mentioned drivers by this series.
> 
> During checking of those modules I noticed that the module info carries
> the "GPL" version tag, which, according to include/linux/module.h, equals
> to "GPL version 2 or later", which (I believe) in turn is a mismatch to
> what is written in the file header's license boilerplates. This series
> corrects this by setting all MODULE_LICENSE() descriptors to "GPL v2",
> which equals to the "GNU GPL version 2 only" phrase.
> 
> Besides that, this fixes some whitespace cosmetics in the headers, and
> removes the link to gnu.org (if existing), which points to the GPLv3
> license anyway.
> 
> The original intention was to fully replace all the licensing headers
> with only the SPDX License Identifiers as it is done in a lot of other
> in-tree drivers nowadays. However, Digital Devices disagreed to do this
> and expressed major concerns regarding this, in that a machine readable
> license tag instead of a full license boilerplate won't hold up equally,
> so we agreed to keep the license boilerplate text as is right now.

That's really odd, who at that company can I talk to about this?  Or
really, what lawyer at that company can I point my lawyer at to talk
about this, that's the only way this is going to get resolved.

If it helps, _ALL_ of the major companies that are kernel developers are
onboard with the removal of the crazy boiler-plate text, so this tiny
holdout should be easy to resolve.

> Greg, I'm Cc'ing you on this due to the last paragraph, as AFAIK you're
> one of the initiators of the SPDX tagging initiative, and you even added
> tags to 10k+ files all over the tree :-) so we maybe can discuss this
> further, also with DD, in the hopes you're fine with this - sorry in
> advance if not.

See my review of your first patch here, this needs to be done a lot
differently...

thanks,

greg k-h

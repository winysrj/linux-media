Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40863 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdBAWuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 17:50:01 -0500
Date: Wed, 1 Feb 2017 22:49:57 +0000
From: Sean Young <sean@mess.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: mchehab@kernel.org, linux-media <linux-media@vger.kernel.org>,
        carlo@caione.org, khilman@baylibre.com,
        linux-amlogic@lists.infradead.org, robh+dt@kernel.org,
        mark.rutland@arm.com, narmstrong@baylibre.com,
        linux-arm-kernel@lists.infradead.org, afaerber@suse.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: devicetree: meson-ir:
 "linux,rc-map-name" is supported
Message-ID: <20170201224957.GA3631@gofer.mess.org>
References: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
 <20170201221415.22794-1-martin.blumenstingl@googlemail.com>
 <CAFBinCDF2d36E2hp7w_ehqdErdZPK9maQLpBmqMoGMPZmTTqqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCDF2d36E2hp7w_ehqdErdZPK9maQLpBmqMoGMPZmTTqqQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 01, 2017 at 11:26:14PM +0100, Martin Blumenstingl wrote:
> On Wed, Feb 1, 2017 at 11:14 PM, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
> > The driver already parses the "linux,rc-map-name" property. Add this
> > information to the documentation so .dts maintainers don't have to look
> > it up in the source-code.
> >
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> > Changes since v1:
> > - removed character which shows up as whitespace from subject
> I have verified that I really sent this without a whitespace (I'm
> using git send-email, so the patch is not mangled by some webmailer) -
> unfortunately it seems to appear again (maybe one of the receiving
> mail-servers or the mailing-list software does something weird here).
> 
> @Mauro: can you handle this when you merge the patch - or do you want
> me to push this to some git repo from which you can pull?

I'll apply it to my rc-tree and fix up any problems.


Sean

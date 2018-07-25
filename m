Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46210 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728595AbeGYKUd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 06:20:33 -0400
Date: Wed, 25 Jul 2018 12:09:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] media: thermal I2C cameras metadata
Message-ID: <20180725090946.wl2tmjgkotcwslmh@valkosipuli.retiisi.org.uk>
References: <CAJCx=g=+GWrPTWpU_AgGKLKWtXY57c=7i-1ijMVdJP=scRqyYw@mail.gmail.com>
 <20180723113521.4enawluordbdfd2p@valkosipuli.retiisi.org.uk>
 <CAJCx=gkYebxOX5DZZtJTJeQW7jzFS5aJ2_PStJ2ZxEfxqutUSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCx=gkYebxOX5DZZtJTJeQW7jzFS5aJ2_PStJ2ZxEfxqutUSA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2018 at 11:05:47PM -0700, Matt Ranostay wrote:
> On Mon, Jul 23, 2018 at 4:35 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Matt,
> >
> > On Sun, Jul 15, 2018 at 11:05:42PM -0700, Matt Ranostay wrote:
> >> Hello et all,
> >>
> >> So currently working with some thermal sensors that have coefficients
> >> that needs to be passed back to userspace that aren't related to the
> >> pixel data but are required to normalize to remove scan patterns and
> >> temp gradients. Was wondering the best way to do this, and hope it
> >> isn't some is kludge of the close captioning, or just passing raw data
> >> as another column line.
> >
> > Are you referring to the EEPROM content or something else?
> >
> > For EEPROM, I could think of just exposing the EEPROM to the user space
> > as-is using the NVMEM API. This information is very, very device specific
> > and therefore using a generic interface to access individual values there
> > isn't really useful.
> >
> 
> Actually that is okay for the EEPROM data that is per sensor, and
> nvram does seem like it would work.
> But there is per video frame data that is required along with the
> static EEPROM data to calculate the actual end result.

Could you point out what that might be on the datasheet?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

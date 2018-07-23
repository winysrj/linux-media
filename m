Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54754 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387906AbeGWMgK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:36:10 -0400
Date: Mon, 23 Jul 2018 14:35:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] media: thermal I2C cameras metadata
Message-ID: <20180723113521.4enawluordbdfd2p@valkosipuli.retiisi.org.uk>
References: <CAJCx=g=+GWrPTWpU_AgGKLKWtXY57c=7i-1ijMVdJP=scRqyYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCx=g=+GWrPTWpU_AgGKLKWtXY57c=7i-1ijMVdJP=scRqyYw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Sun, Jul 15, 2018 at 11:05:42PM -0700, Matt Ranostay wrote:
> Hello et all,
> 
> So currently working with some thermal sensors that have coefficients
> that needs to be passed back to userspace that aren't related to the
> pixel data but are required to normalize to remove scan patterns and
> temp gradients. Was wondering the best way to do this, and hope it
> isn't some is kludge of the close captioning, or just passing raw data
> as another column line.

Are you referring to the EEPROM content or something else?

For EEPROM, I could think of just exposing the EEPROM to the user space
as-is using the NVMEM API. This information is very, very device specific
and therefore using a generic interface to access individual values there
isn't really useful.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

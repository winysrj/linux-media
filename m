Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33394 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753373AbdK2JIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 04:08:20 -0500
Date: Wed, 29 Nov 2017 11:08:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jeremy Sowden <jeremy@azazel.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] media: staging: atomisp: defined as static some
 const arrays which don't need external linkage.
Message-ID: <20171129090817.3u7bfxa3dapue44t@valkosipuli.retiisi.org.uk>
References: <20171127113054.27657-1-jeremy@azazel.net>
 <20171127113054.27657-3-jeremy@azazel.net>
 <20171127122125.GB8561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127122125.GB8561@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Mon, Nov 27, 2017 at 01:21:25PM +0100, Greg KH wrote:
> On Mon, Nov 27, 2017 at 11:30:53AM +0000, Jeremy Sowden wrote:
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++++++++++-----------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> I can never take patches without any changelog text, and so no one
> should write them that way :)

I've been applying the atomisp patches to my tree for some time now,
further on passing them to Mauro to be merged via the media tree. To avoid
conflicts, I suggest to avoid merging them via the staging tree.

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

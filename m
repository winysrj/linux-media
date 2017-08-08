Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60584 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752223AbdHHNA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:00:28 -0400
Date: Tue, 8 Aug 2017 16:00:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Joe Perches <joe@perches.com>
Cc: "Sergei A. Trusov" <sergei.a.trusov@ya.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@llwyncelyn.cymru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        simran singhal <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] media: staging: atomisp: sh_css_calloc shall return a
 pointer to the allocated space
Message-ID: <20170808130025.zviaw4ddxzn7skaa@valkosipuli.retiisi.org.uk>
References: <1859135.Zd3QESt5CR@z12>
 <1501661466.31625.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501661466.31625.3.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 02, 2017 at 01:11:06AM -0700, Joe Perches wrote:
> On Wed, 2017-08-02 at 18:00 +1000, Sergei A. Trusov wrote:
> > The calloc function returns either a null pointer or a pointer to the
> > allocated space. Add the second case that is missed.
> 
> gads.
> 
> Bug added by commit da22013f7df4 ("atomisp: remove indirection from
> sh_css_malloc")
> 
> These wrappers should really be deleted.

Applied, with the appropriate Fixes: header.

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

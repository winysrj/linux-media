Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49601 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751911AbbDJT5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 15:57:55 -0400
Date: Fri, 10 Apr 2015 22:57:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 10 (media/i2c/adp1653)
Message-ID: <20150410195747.GI20756@valkosipuli.retiisi.org.uk>
References: <20150410211806.574ae8f9@canb.auug.org.au>
 <5528071C.2040102@infradead.org>
 <55280783.20405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55280783.20405@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy and others,

On Fri, Apr 10, 2015 at 10:25:23AM -0700, Randy Dunlap wrote:
...
> > ../drivers/media/i2c/adp1653.c:433:6: warning: unused variable 'gpio' [-Wunused-variable]
> >   int gpio;

A preliminary patch for adp1653 DT support was accidentally merged to
media-tree. It's now reverted in media-tree:

---
commit be8e58d93fba531b12ef2fce4fb33c9c5fb5b69f
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Thu Apr 9 07:33:45 2015 -0300

    Revert "[media] Add device tree support to adp1653 flash driver"
    
    As requested by Sakari:
    
        "The driver changes are still being reviewed.
         It's been proposed that the max-microamp property be renamed."
    
    So, as the DT bindings are not agreed upstream yet, let's revert
    it.
    
    Requested-by: Sakari Ailus <sakari.ailus@iki.fi>
    This reverts commit b6100f10bdc2019a65297d2597c388de2f7dd653.
---

I thus believe the problem in linux-next should disappear by itself. In the
meantime, the revert from media-tree could be used if needed.

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

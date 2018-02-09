Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48950 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750863AbeBIMtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:49:13 -0500
Date: Fri, 9 Feb 2018 14:49:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 00/15] Media Controller compliance fixes
Message-ID: <20180209124910.yt7cv5gcz5wasfcy@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180209124806.4ukqlf6vejgloiua@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180209124806.4ukqlf6vejgloiua@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 09, 2018 at 02:48:07PM +0200, Sakari Ailus wrote:
> On Thu, Feb 08, 2018 at 09:36:40AM +0100, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Hi all,
> > 
> > I've been posting random patches fixing various MC problems, but it is
> > easier to see them all in a single patch series.
> > 
> > All patches except 13 and 14 are identical to was I posted earlier.
> > For 13 and 14 I decided to drop the requirement that the application
> > clears the reserved field. Only the driver will clear it.
> 
> Thanks!
> 
> For patches 5, 7, 8, 10, 12 and 14:

And patches 1 and 2 as well.

> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

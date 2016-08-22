Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34008 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754104AbcHVMcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:32:13 -0400
Date: Mon, 22 Aug 2016 15:32:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, m.chehab@osg.samsung.com,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v2 11/17] media: Add release callback for media device
Message-ID: <20160822123207.GA12130@valkosipuli.retiisi.org.uk>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-12-git-send-email-sakari.ailus@linux.intel.com>
 <38c5a57a-04ce-1109-ce73-1ba23e3cb1cb@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c5a57a-04ce-1109-ce73-1ba23e3cb1cb@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Aug 22, 2016 at 02:24:59PM +0200, Hans Verkuil wrote:
> On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> > The release callback may be used by the driver to signal the release of
> > the media device. This makes it possible to embed a driver private struct
> > to the same memory allocation.
> 
> This is a bit weird: you either add support for private data with a priv
> pointer as in the previous patch, or you allow for larger structs.
> 
> Doing both doesn't seem right. In both cases you want the release callback,
> so that's fine. But I think you should pick which method you want to keep
> private data around.
> 
> I have a slight preference for a priv pointer, but I'm OK with either solution.

I'll drop the size parameter in the next version.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

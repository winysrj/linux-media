Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38147 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754868AbaGQLx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:53:56 -0400
Date: Thu, 17 Jul 2014 14:53:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Set entity->links NULL in cleanup
Message-ID: <20140717115349.GN16460@valkosipuli.retiisi.org.uk>
References: <1401197269-18773-1-git-send-email-sakari.ailus@linux.intel.com>
 <3533594.Ac4LJj8QGP@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3533594.Ac4LJj8QGP@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jul 17, 2014 at 01:43:09PM +0200, Laurent Pinchart wrote:
> On Tuesday 27 May 2014 16:27:49 Sakari Ailus wrote:
> > Calling media_entity_cleanup() on a cleaned-up entity would result into
> > double free of the entity->links pointer and likely memory corruption as
> > well.
> 
> My first question is, why would anyone do that ? :-)

Because it makes error handling easier. Many cleanup functions work this
way, but not media_entity_cleanup().

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

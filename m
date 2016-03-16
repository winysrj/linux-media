Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56914 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932868AbcCPOLB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 10:11:01 -0400
Date: Wed, 16 Mar 2016 16:10:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] [media] media-device: get rid of the spinlock
Message-ID: <20160316141057.GY11084@valkosipuli.retiisi.org.uk>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 16, 2016 at 09:04:02AM -0300, Mauro Carvalho Chehab wrote:
> Right now, the lock schema for media_device struct is messy,
> since sometimes, it is protected via a spin lock, while, for
> media graph traversal, it is protected by a mutex.
> 
> Solve this conflict by always using a mutex.
> 
> As a side effect, this prevents a bug where the media notifiers
> were called at atomic context.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The scope of mdev->lock isn't much, really. I think this is fine, no need to
create another mutex.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

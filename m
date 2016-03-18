Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39992 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932158AbcCRNKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 09:10:46 -0400
Date: Fri, 18 Mar 2016 15:10:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 4/5] [media] media-device: use kref for media_device
 instance
Message-ID: <20160318131041.GC11084@valkosipuli.retiisi.org.uk>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
 <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82ef082c4de7c0a1c546da1d9e462bc86ab423bf.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 16, 2016 at 09:04:05AM -0300, Mauro Carvalho Chehab wrote:
> Now that the media_device can be used by multiple drivers,
> via devres, we need to be sure that it will be dropped only
> when all drivers stop using it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

For patches 2 (assuming fixes according to Javier's comment), 4 and 5, and
"[media] media: rename media unregister function":

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

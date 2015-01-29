Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43640 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbA2UBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:01:00 -0500
Date: Thu, 29 Jan 2015 18:00:55 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [GIT FIXES FOR v3.19] smiapp compile fix for non-OF
 configuration
Message-ID: <20150129180055.4823e1fd@recife.lan>
In-Reply-To: <20150127103649.GI17565@valkosipuli.retiisi.org.uk>
References: <20150127103649.GI17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Jan 2015 12:36:49 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> The recent smiapp OF support patches contained a small issue related to
> reading 64-bit numbers from the device tree, such that the compilation fails
> if CONFIG_OF is undefined.
> 
> This patch provides a temporary fix to the matter. The proper one is to use
> of_property_read_u64_array(), but that's currently not exported. I've
> submitted a patch for that.

Didn't apply at fixes, so I applied it at the master development branch.

If this is really needed for 3.19, please backport against 3.19-rc6.

Regards,
Mauro

> 
> Please pull.
> 
> 
> The following changes since commit e32b31ae45c18679c186e67aa41d0e2318cae487:
> 
>   [media] mb86a20s: remove unused debug modprobe parameter (2015-01-26 10:08:29 -0200)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git smiapp-of-compile
> 
> for you to fetch changes up to 45fe24236dd638b170a7ca91a3aa0e9b2b153889:
> 
>   smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined (2015-01-27 12:18:49 +0200)
> 
> ----------------------------------------------------------------
> Sakari Ailus (1):
>       smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined
> 
>  drivers/media/i2c/smiapp/smiapp-core.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38424 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932933AbbBCMAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 07:00:54 -0500
Date: Tue, 3 Feb 2015 14:00:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [GIT FIXES FOR v3.19] smiapp compile fix for non-OF configuration
Message-ID: <20150203120020.GB32575@valkosipuli.retiisi.org.uk>
References: <20150127103649.GI17565@valkosipuli.retiisi.org.uk>
 <20150129180055.4823e1fd@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129180055.4823e1fd@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Jan 29, 2015 at 06:00:55PM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 27 Jan 2015 12:36:49 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > The recent smiapp OF support patches contained a small issue related to
> > reading 64-bit numbers from the device tree, such that the compilation fails
> > if CONFIG_OF is undefined.
> > 
> > This patch provides a temporary fix to the matter. The proper one is to use
> > of_property_read_u64_array(), but that's currently not exported. I've
> > submitted a patch for that.
> 
> Didn't apply at fixes, so I applied it at the master development branch.
> 
> If this is really needed for 3.19, please backport against 3.19-rc6.

Indeed; the master branch is where it belongs to. Thanks!

v3.19 will not have OF support yet so it's fine.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

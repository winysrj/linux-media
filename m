Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56198 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753652AbcEaVW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 17:22:28 -0400
Date: Wed, 1 Jun 2016 00:22:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv5] support for AD5820 camera auto-focus coil
Message-ID: <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
References: <20160517181927.GA28741@amd>
 <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160527205140.GA26767@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Fri, May 27, 2016 at 10:51:40PM +0200, Pavel Machek wrote:
> 
> This adds support for AD5820 autofocus coil, found for example in
> Nokia N900 smartphone.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

The patch looks good to me but then I came to think of a question I've
missed so far: is there DT documentation somewhere for the properties used
by the driver? I might put that to a separate patch, and cc the relevant
list.

Whether we decide to have the module in DT or not is orthogonal to this.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

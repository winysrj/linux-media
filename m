Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33664 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbcHEKbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 06:31:14 -0400
Date: Fri, 5 Aug 2016 12:30:51 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20160805103051.GP30047@pali>
References: <20160517181927.GA28741@amd>
 <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160805102611.GA13116@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 05 August 2016 12:26:11 Pavel Machek wrote:
> 
> This adds support for AD5820 autofocus coil, found for example in
> Nokia N900 smartphone.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Pali Rohár <pali.rohar@gmail.com>

> ---
> v2: simple cleanups, fix error paths, simplify probe
> v3: more cleanups, remove printk, add include
> v4: remove header file.
> v5: switch to devm_ , style cleanups, fixes
> v6: remove new userspace APIs.
> 
> Can we finally get the patch in, please?

This patch is on ML for months or years, right?
Please merge it...

-- 
Pali Rohár
pali.rohar@gmail.com

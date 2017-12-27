Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30673 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdL0VR0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 16:17:26 -0500
Date: Wed, 27 Dec 2017 23:17:19 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: v4.15: camera problems on n900
Message-ID: <20171227211718.favif66afztygfje@kekkonen.localdomain>
References: <20171227210543.GA19719@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171227210543.GA19719@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 27, 2017 at 10:05:43PM +0100, Pavel Machek wrote:
> Hi!
> 
> In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
> seconds, but then I get repeated oopses.
> 
> On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
> camera does not start.	  
> 
> Any ideas what might be wrong there?

What kind of oopses do you get?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

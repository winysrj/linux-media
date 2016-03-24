Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39882 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755246AbcCXKDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 06:03:34 -0400
Date: Thu, 24 Mar 2016 12:03:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 0/4]  Some fixes and cleanups for the Media Controller
 code
Message-ID: <20160324100329.GB32125@valkosipuli.retiisi.org.uk>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1458760750.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 23, 2016 at 04:27:42PM -0300, Mauro Carvalho Chehab wrote:
> The first three patches in this series are simple cleanup patches.
> No functional changes.
> 
> The final patch fixes a longstanding bug at the Media Controller framework:
> it prevents race conditions when the /dev/media? device is being removed,
> while some program is still accessing it.
> 
> I tested it with au0828 and snd-usb-audio and the issues I was noticing 
> before it disappeared.
> 
> Shuah,
> 
> Could you please test it also?

Patches 1--3:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I agree with Laurent's comment on patch 1.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

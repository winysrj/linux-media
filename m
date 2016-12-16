Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59239 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761023AbcLPOQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 09:16:34 -0500
Date: Fri, 16 Dec 2016 14:16:30 +0000
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v5 2/6] [media] rc-main: split setup and unregister
 functions
Message-ID: <20161216141629.GA32757@gofer.mess.org>
References: <20161216061218.5906-1-andi.shyti@samsung.com>
 <20161216061218.5906-3-andi.shyti@samsung.com>
 <20161216121026.GA31618@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216121026.GA31618@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

On Fri, Dec 16, 2016 at 12:10:26PM +0000, Sean Young wrote:
> Sorry to add to your woes, but there are some checkpatch warnings and
> errors. Please can you correct these. One is below.

Actually, the changes are pretty minor, I can fix them up before sending
them to Mauro. Sorry for bothering you.


Sean

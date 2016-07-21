Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbcGUAsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 20:48:16 -0400
Date: Thu, 21 Jul 2016 09:48:12 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 5/7] [media] ir-lirc-codec: do not handle any buffer for raw
 transmitters
Message-id: <20160721004812.GF23521@samsunx.samsung>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-6-git-send-email-andi.shyti@samsung.com>
 <CGME20160719221617epcas1p45a886e86e2040ce40565acd32d778555@epcas1p4.samsung.com>
 <20160719221610.GC24697@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160719221610.GC24697@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > Raw transmitters receive the data which need to be sent to
> > receivers from userspace as stream of bits, they don't require
> > any handling from the lirc framework.
> 
> No drivers of type RC_DRIVER_IR_RAW_TX should handle tx just like any
> other device, so data should be provided as an array of u32 alternating
> pulse-space. If your device does not handle input like that then convert
> it into that format in the driver. Every other driver has to do some
> sort of conversion of that kind.

I don't see anything wrong here, that's how it works for example
in Tizen or in Android for the boards I'm on: userspace sends a
stream of bits that are then submitted to the IR as they are.

If I change it to only pulse-space domain, then I wouldn't
provide support for those platforms. Eventually I can add a new
protocol.

Andi

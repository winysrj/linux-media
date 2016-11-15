Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41127 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753042AbcKOTS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 14:18:57 -0500
Message-Id: <1479237536.506544.788777817.10BEA636@webmail.messagingengine.com>
From: Edgar Thier <info@edgarthier.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Date: Tue, 15 Nov 2016 20:18:56 +0100
References: <87h97achun.fsf@edgarthier.net> <1640565.qtzjRM8HWd@avalon>
 <20161115170402.GY3217@valkosipuli.retiisi.org.uk>
 <4228838.ihduIDFkeB@avalon>
In-Reply-To: <4228838.ihduIDFkeB@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> Which device(s) support these formats ?

As mentioned in my last mail, I took the freedom and uploaded the lsusb
-v output for 3 cameras with
bayer 16-bit patterns. You can find them here:

dfk23up1300_16bitbayer_RG.lsusb:  http://pastebin.com/PDdY7rs0
dfk23ux249_16bitbayer_GB.lsusb: http://pastebin.com/gtjF3Q2k
dfk33ux250_16bitbayer_GR.lsusb: http://pastebin.com/Errz5UMr

All 3 are USB 3.0 industrial cameras by 'The Imaging Source'.

> And could you please try to fix your e-mail client and/or server to avoid corrupting patches ?

I am not sure what is wrong but I will look into it.

Cheers,

Edgar

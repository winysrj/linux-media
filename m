Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp90.iad3a.emailsrvr.com ([173.203.187.90]:42002 "EHLO
        smtp90.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753261AbdIDHvo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 03:51:44 -0400
Subject: Re: UVC property auto update
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
 <Pine.LNX.4.64.1709031714570.29016@axis700.grange>
From: Edgar Thier <edgar.thier@theimagingsource.com>
Message-ID: <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com>
Date: Mon, 4 Sep 2017 09:45:15 +0200
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1709031714570.29016@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

The cameras in question are USB-3.0 industrial cameras from The Imaging Source.
The ones I tested were the DFK UX250 and DFK UX264 models.
I do not know if there are other devices that have the AUTO_UPDATE flag for various properties.

Since I received no immediate answer I tried fixing it myself.
The result can be found here:
https://patchwork.linuxtv.org/patch/43289/

Cheers,

Edgar

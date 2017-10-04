Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:59977 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbdJDIot (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 04:44:49 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 34ACE20A85
        for <linux-media@vger.kernel.org>; Wed,  4 Oct 2017 10:44:47 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Oct 2017 10:44:45 +0200
From: Martin Kepplinger <martink@posteo.de>
To: p.zabel@pengutronix.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Subject: platform: coda: how to use firmware-imx binary
 =?UTF-8?Q?releases=3F?=
Message-ID: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Commit

     be7f1ab26f42 media: coda: mark CODA960 firmware versions 2.3.10 and 
3.1.1 as supported

says firmware version 3.1.1 revision 46072 is contained in 
"firmware-imx-5.4.bin", that's probably

     sha1  78a416ae88ff01420260205ce1d567f60af6847e  firmware-imx-5.4.bin

How do I use this in order to get a VPU firmware blob that the coda 
platform driver can work with?



(Maybe it'd be worth adding some short documentation on this. There 
doesn't seem to be a
devicetree bindings doc for coda in 
Documentation/devicetree/bindings/media which would
be a good place for documenting how to use these binaries too)

thanks

                                    martin

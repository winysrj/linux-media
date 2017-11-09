Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:57149 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbdKIWOy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 17:14:54 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 2FD0220914
        for <linux-media@vger.kernel.org>; Thu,  9 Nov 2017 23:14:53 +0100 (CET)
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
From: Martin Kepplinger <martink@posteo.de>
Subject: media: coda: sources of coda_regs.h?
Message-ID: <15f29890-d029-95a3-c00d-73ed566ff172@posteo.de>
Date: Thu, 9 Nov 2017 23:14:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

As I'm reading up on the coda driver a little, I can't seem to find the
vendor's sources for the coda_regs.h definitions. Could you point me to
them?

As they don't seem to be in the imx reference manual nor the vpu API
manual, I think it would be worth including a comment about the source
in the header file.

and thanks for this driver. It seems to make the best possible use of
this remaining firmware binary, really :)

                           martin

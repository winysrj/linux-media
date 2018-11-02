Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.bgcomp.co.uk ([81.187.35.205]:57691 "EHLO
        mailgate.bgcomp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbeKCHGM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2018 03:06:12 -0400
Received: from eth7.localnet (www.bgcomp.co.uk [IPv6:2001:8b0:ca:2::fd])
        by mailgate.bgcomp.co.uk (Postfix) with ESMTP id AD9D71BDF
        for <linux-media@vger.kernel.org>; Fri,  2 Nov 2018 21:48:33 +0000 (GMT)
From: Bob Goddard <kernel@1.kernel.bgcomp.co.uk>
To: linux-media@vger.kernel.org
Subject: diffs in mn88473 & cxd2841er config structures
Date: Fri, 02 Nov 2018 21:48:33 +0000
Message-ID: <17343705.H5kqrNrpiY@eth7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I am trying to add in support for the cxd2841er on the rtl28x usb devices.

With mn88473 and others, the config structure has 'struct dvb_frontend **fe', but it's not in the cxd2841er config.

Are there any plans to add it in? Should I change it and wherever else it is required, or should it be left in its current format?




B

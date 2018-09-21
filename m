Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:53541 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeIUOmF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 10:42:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.macqel.be (Postfix) with ESMTP id 0433E130D3E
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 10:54:12 +0200 (CEST)
Received: from smtp2.macqel.be ([127.0.0.1])
        by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DDhmf+zgsRIg for <linux-media@vger.kernel.org>;
        Fri, 21 Sep 2018 10:54:11 +0200 (CEST)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
        by smtp2.macqel.be (Postfix) with ESMTP id 5F936130D3A
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 10:54:11 +0200 (CEST)
Date: Fri, 21 Sep 2018 10:54:11 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: linux-media@vger.kernel.org
Subject: ? recommended way to implement gain control
Message-ID: <20180921085411.GA31130@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I see there's an ongoing discussion about implementing gain control for
imx208.  I have a similar problem (in the sense that the documentation
of V4L2_CID_GAIN does not answer my question).  The IMX264 has only
one gain control, ranging from 0 to 480, but the unit is 'tenth of dB'.
How can I make that clear for a V4L2 client ?

Best regards

Philippe

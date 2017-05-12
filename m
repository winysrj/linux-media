Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34740 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758650AbdELTDD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 15:03:03 -0400
Received: by mail-oi0-f49.google.com with SMTP id b204so76570155oii.1
        for <linux-media@vger.kernel.org>; Fri, 12 May 2017 12:03:02 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Doyle <wpdster@gmail.com>
Date: Fri, 12 May 2017 15:02:31 -0400
Message-ID: <CAF_dkJB=2PNbD79msw=G47U-6QkajDOWwLJbr3pCaTQeqn=fXA@mail.gmail.com>
Subject: Is it possible to have a binary blob custom control?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to transfer a binary blob of data to my V4L2 device
driver.  Is there a way I can do this through the V4L2 "control"
framework?  Or should I implement a custom ioctl to do that?

Any recommendations or examples?

Thank you.

--wpd

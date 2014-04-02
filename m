Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46382 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaDBR1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 13:27:07 -0400
Received: by mail-oa0-f46.google.com with SMTP id i7so636245oag.33
        for <linux-media@vger.kernel.org>; Wed, 02 Apr 2014 10:27:07 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Apr 2014 10:27:06 -0700
Message-ID: <CABMudhSFxsW6YZRCt9BohPOatcZiZck9KYnF9BkiCUsvsqy0Ug@mail.gmail.com>
Subject: How to enable debug statements in v4l2 framework
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In drivers/media/v4l2-core/videobuf2-core.c, I see debug printfs ilke this.
I want to know how can I enable debug statements in v42l framework?

 #define dprintk(level, fmt, arg...)                                    \
        do {                                                            \
               if (debug >= level)                                     \
                       printk(KERN_DEBUG "vb2: " fmt, ## arg);         \
        } while (0)

Thank you.

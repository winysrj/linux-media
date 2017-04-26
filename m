Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34025 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdDZRAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 13:00:01 -0400
Received: by mail-wr0-f173.google.com with SMTP id l9so3652935wre.1
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 10:00:00 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Subject: em28xx debug module parameters
Message-ID: <397bf767-e1be-ea3f-ecff-b761bc25fe34@googlemail.com>
Date: Wed, 26 Apr 2017 19:00:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

is there a chance that we can clean up the em28xx debug module parameter
mess ?
There are currently 8 (!) of them.
Do we have to maintain them all forever as "stable userspace interface" ?

For example:
- "reg_debug" is actually used for usb control message debugging
- "core_debug" is abused for usb isoc debugging and not used for
anything else
- there is a module parameter "isoc_debug", too, but it is used by
em28xx-v4l only
...

Regards,
Frank

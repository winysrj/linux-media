Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:45082 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdKXBAY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 20:00:24 -0500
Received: from mail-qt0-f172.google.com (unknown [209.85.216.172])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 09:00:15 +0800 (CST)
Received: by mail-qt0-f172.google.com with SMTP id j12so7996436qtc.9
        for <linux-media@vger.kernel.org>; Thu, 23 Nov 2017 17:00:17 -0800 (PST)
MIME-Version: 1.0
From: Jacob Chen <jacob-chen@iotwrt.com>
Date: Fri, 24 Nov 2017 09:00:14 +0800
Message-ID: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
Subject: notifier is skipped in some situations
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I encountered a problem when using async sub-notifiers.

It's like that:
    There are two notifiers, and they are waiting for one subdev.
    When this subdev is probing, only one notifier is completed and
the other one is skipped.

I found that in v15 of patch "v4l: async: Allow binding notifiers to
sub-devices", "v4l2_async_notifier_complete" is replaced by
v4l2_async_notifier_call_complete, which make it only complete one
notifier.

Why is it changed? Can this be fixed?

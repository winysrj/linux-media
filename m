Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35607 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755185AbcJLPeQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:34:16 -0400
Received: by mail-vk0-f53.google.com with SMTP id 192so48551877vkl.2
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2016 08:33:37 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?= <wuchengli@google.com>
Date: Wed, 12 Oct 2016 23:33:16 +0800
Message-ID: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
Subject: V4L2_DEC_CMD_STOP and last_buffer_dequeued
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        pawel@osciak.com
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to use V4L2_DEC_CMD_STOP to implement flush. First the
userspace sent V4L2_DEC_CMD_STOP to initiate the flush. The driver set
V4L2_BUF_FLAG_LAST on the last CAPTURE buffer. I thought implementing
V4L2_DEC_CMD_START in the driver was enough to start the decoder. But
last_buffer_dequeued had been set to true in v4l2 core. I couldn't
clear last_buffer_dequeued without calling STREAMOFF from the
userspace. If I need to call STREAMOFF/STREAMON after
V4L2_DEC_CMD_STOP, it looks like V4L2_DEC_CMD_START is not useful. Did
I miss anything?

Regards,
Wu-Cheng

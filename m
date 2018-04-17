Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37140 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752665AbeDQEeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:34:11 -0400
Received: by mail-it0-f45.google.com with SMTP id 71-v6so14512850ith.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:10 -0700 (PDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com. [209.85.223.179])
        by smtp.gmail.com with ESMTPSA id j197sm2505598ioj.45.2018.04.16.21.34.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:34:07 -0700 (PDT)
Received: by mail-io0-f179.google.com with SMTP id y128so20755889iod.4
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:33:56 +0000
Message-ID: <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 00/29] Request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Hi all,

> This is a cleaned up version of the v10 series (never posted to
> the list since it was messy).

Hi Hans,

It took me a while to test and review this, but finally have been able to
do it.

First the result of the test: I have tried porting my dummy vim2m test
program
(https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42 for
reference),
and am getting a hang when trying to queue the second OUTPUT buffer (right
after
queuing the first request). If I move the calls the VIDIOC_STREAMON after
the
requests are queued, the hang seems to happen at that moment. Probably a
deadlock, haven't looked in detail yet.

I have a few other comments, will follow up per-patch.

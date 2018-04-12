Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:43307 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbeDLJC1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 05:02:27 -0400
Received: by mail-vk0-f48.google.com with SMTP id v134so2793606vkd.10
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 02:02:26 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id m19sm1664975vkf.31.2018.04.12.02.02.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Apr 2018 02:02:25 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id r19so2800592vkf.4
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 02:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-27-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-27-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 12 Apr 2018 09:02:14 +0000
Message-ID: <CAAFQd5CjKys=gPetj8fJE8=rVDjMh4bQdT1Pf+NHfBWCmj+rjQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 26/29] vim2m: use workqueue
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
> interrupt context. Switch to a workqueue instead.

Could it make more sense to just replace the old (non-hr) timer used in
this driver with delayed work?

Best regards,
Tomasz

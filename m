Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f179.google.com ([209.85.210.179]:41256 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3BDNX5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 08:23:57 -0500
Received: by mail-ia0-f179.google.com with SMTP id x24so7977626iak.38
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 05:23:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 4 Feb 2013 10:23:55 -0300
Message-ID: <CALF0-+VvLRmLJB3g=sM4nMPmR=fQS_BnS_j2UmPPwKzt-112KA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Arvydas Sidorenko <asido4@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Mon, Feb 4, 2013 at 9:36 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This patch series updates this driver to the control framework, switches
> it to unlocked_ioctl, fixes a variety of V4L2 compliance issues.
>
> It compiles, but to my knowledge nobody has hardware to test this :-(
>
> If anyone has hardware to test this, please let me know!
>

I've sent a patch for stk-webcam recently and Arvydas Sidorenko (in
Cc) was kind enough to test it.

@Arvydas: If you're not too busy, we'd really appreciate a lot
if you can test this series.

Thanks a lot,

-- 
    Ezequiel

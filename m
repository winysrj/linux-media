Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53321 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752066AbeENMJ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 08:09:27 -0400
Subject: Re: [RFC PATCH 0/6] v4l2 core: push ioctl lock down to ioctl handler
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
Message-ID: <34da836c-2ac6-2005-2f06-c8cd0cb1d158@xs4all.nl>
Date: Mon, 14 May 2018 14:09:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180514115602.9791-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On 05/14/2018 01:55 PM, Hans Verkuil wrote:
> Mike, can you test this patch? I tried to test it but my pvrusb2
> fails in a USB transfer (unrelated to this patch). I'll mail you
> separately with the details, since I've no idea what is going on.

Never mind. After unplugging the power and plugging it back in it is
now working.

Not sure what happened, but at least I can test this now, and it looks
fine.

BTW, v4l2-compliance complains about a lot of things, and I get a lot
of sysfs kernel warnings when I unplug the device.

Regards,

	Has

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbeJGGJF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Oct 2018 02:09:05 -0400
Date: Sat, 6 Oct 2018 19:03:59 -0400
From: Sasha Levin <sashal@kernel.org>
To: Dafna Hirschfeld <dafna3@gmail.com>
Cc: isely@pobox.com, mchehab@kernel.org, helen.koike@collabora.com,
        hverkuil@xs4all.nl, outreachy-kernel@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Outreachy kernel] [PATCH vicodec] media: pvrusb2: replace
 `printk` with `pr_*`
Message-ID: <20181006230359.GB32006@sasha-vm>
References: <20181006192138.11349-1-dafna3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20181006192138.11349-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 06, 2018 at 10:21:38PM +0300, Dafna Hirschfeld wrote:
>Replace calls to `printk` with the appropriate `pr_*`
>macro.

Hi Dafna,

I'd encourage you to look into the dev_ family of print functions (such
as dev_info() ). They can avoid having to repeat the driver name in
every print call.

--
Thanks,
Sasha

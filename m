Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63578 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3GKRZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 13:25:36 -0400
Received: by mail-wi0-f177.google.com with SMTP id ey16so7841559wid.10
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 10:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306270855.49444.hverkuil@xs4all.nl>
References: <201306270855.49444.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 11 Jul 2013 22:55:15 +0530
Message-ID: <CA+V-a8sYvBWGJGBF6JWwjKHwW_4Ew8wp6yBQnCrpeebAkJ4EmA@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.11]
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jun 27, 2013 at 12:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> (Same as my previous git pull message, but with more cleanup patches and
[snip]
> Lad, Prabhakar (9):
>       media: i2c: ths8200: support asynchronous probing
>       media: i2c: ths8200: add OF support
>       media: i2c: adv7343: add support for asynchronous probing
>       media: i2c: tvp7002: add support for asynchronous probing
>       media: i2c: tvp7002: remove manual setting of subdev name
>       media: i2c: tvp514x: remove manual setting of subdev name
>       media: i2c: tvp514x: add support for asynchronous probing
>       media: davinci: vpif: capture: add V4L2-async support
>       media: davinci: vpif: display: add V4L2-async support
>
I see last two patches missing in Mauro's pull request for v3.11 and v3.11-rc1.

Regards,
--Prabhakar Lad

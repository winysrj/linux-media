Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63469 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3EaHuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 03:50:21 -0400
Received: by mail-vc0-f182.google.com with SMTP id gf12so833496vcb.41
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 00:50:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369837147-8747-2-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
	<1369837147-8747-2-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 31 May 2013 15:50:20 +0800
Message-ID: <CAHG8p1Bs66ih6_COQynE6hOhriwSLQNp9C=eC6CMWFs+te9FHg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/14] adv7183: fix querystd
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/5/29 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> If no signal is detected, return V4L2_STD_UNKNOWN. Otherwise AND the standard
> with the detected standards.
>
> Note that the v4l2 core initializes the std with tvnorms before calling the
> querystd ioctl.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>  drivers/media/i2c/adv7183.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

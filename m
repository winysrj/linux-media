Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34790 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbbDPJsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 05:48:12 -0400
Received: by oiko83 with SMTP id o83so41446076oik.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 02:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428574888-46407-7-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
	<1428574888-46407-7-git-send-email-hverkuil@xs4all.nl>
Date: Thu, 16 Apr 2015 17:48:11 +0800
Message-ID: <CAHG8p1BeZtc=xnQa5h5BcH0iR6fzzRWiH=11D21shnVWg+QXUA@mail.gmail.com>
Subject: Re: [PATCH 6/7] v4l2: replace s_mbus_fmt by set_fmt in bridge drivers
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-04-09 18:21 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Replace all calls to s_mbus_fmt in bridge drivers by calls to the
> set_fmt pad op.
>
> Remove the old try/s_mbus_fmt video ops since they are now no longer used.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---

>  drivers/media/platform/blackfin/bfin_capture.c     |  8 +--

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

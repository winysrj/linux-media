Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35369 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbbDPJu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 05:50:28 -0400
Received: by oign205 with SMTP id n205so41861042oig.2
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 02:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428574888-46407-6-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
	<1428574888-46407-6-git-send-email-hverkuil@xs4all.nl>
Date: Thu, 16 Apr 2015 17:50:27 +0800
Message-ID: <CAHG8p1APjh0jojGvH3GcnyrKYE08fzQUFVZj_0UhxFi3D6Cz6w@mail.gmail.com>
Subject: Re: [PATCH 5/7] v4l2: replace try_mbus_fmt by set_fmt in bridge drivers
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-04-09 18:21 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Replace all calls to try_mbus_fmt in bridge drivers by calls to the
> set_fmt pad op.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/pci/saa7134/saa7134-empress.c        | 11 +++---
>  drivers/media/platform/blackfin/bfin_capture.c     | 15 ++++----

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

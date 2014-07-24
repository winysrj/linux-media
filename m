Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47117 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbaGXHQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 03:16:17 -0400
Received: by mail-vc0-f177.google.com with SMTP id hy4so4230421vcb.36
        for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 00:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406109436-23922-3-git-send-email-sonic.adi@gmail.com>
References: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
	<1406109436-23922-3-git-send-email-sonic.adi@gmail.com>
Date: Thu, 24 Jul 2014 15:16:16 +0800
Message-ID: <CAHG8p1BaWtbm7_VQ=4MCoj6aKv-FKkN_AjgqcurvgY8iCM4ANQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] v4l2: blackfin: select proper pinctrl state in
 ppi_set_params if CONFIG_PINCTRL is enabled
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-07-23 17:57 GMT+08:00 Sonic Zhang <sonic.adi@gmail.com>:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Multiple pinctrl states are defined for 8, 16 and 24 data pin groups in PPI peripheral.
> The driver should select correct group before set up further PPI parameters.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:54005 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3DXJ0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 05:26:40 -0400
Received: by mail-vc0-f172.google.com with SMTP id hx10so1589449vcb.3
        for <linux-media@vger.kernel.org>; Wed, 24 Apr 2013 02:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51688A85.8080206@gmail.com>
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
	<1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com>
	<51688A85.8080206@gmail.com>
Date: Wed, 24 Apr 2013 17:26:39 +0800
Message-ID: <CAHG8p1B2meHySHWnQ6JAhDA+2Cgfyc=JHcAG8eY9GhcpN7B5iA@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>
>> +       struct v4l2_device v4l2_dev;
>> +       /* v4l2 control handler */
>> +       struct v4l2_ctrl_handler ctrl_handler;
>
>
> This handler seems to be unused, I couldn't find any code adding controls
> to it. Any initialization of this handler is a dead code now. You probably
> want to move that bits to a patch actually adding any controls.
>

This host driver doesn't support any control but without it subdev
controls can't be accessed.
v4l2_ctrl_add_handler should just return 0 if v4l2_dev->ctrl_handler is NULL.

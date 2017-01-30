Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60129
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752432AbdA3QxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 11:53:00 -0500
Date: Mon, 30 Jan 2017 14:44:55 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 4.11] RC updates
Message-ID: <20170130144455.2f68df7d@vento.lan>
In-Reply-To: <20161227204548.GA18181@gofer.mess.org>
References: <20161227204548.GA18181@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Dec 2016 20:45:48 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> This pull request is for the ir-spi driver, wakeup changes along
> with the required IR encoders, staging updates.

Patches merged.

>  delete mode 100644 drivers/staging/media/lirc/lirc_bt829.c
>  delete mode 100644 drivers/staging/media/lirc/lirc_imon.c
>  delete mode 100644 drivers/staging/media/lirc/lirc_parallel.c
>  delete mode 100644 drivers/staging/media/lirc/lirc_parallel.h

Thanks for that! Yeah, we should get rid of the stuff under staging and
that nobody cares enough to fix ;)

Regards,
Mauro

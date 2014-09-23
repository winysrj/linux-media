Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37113 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaIWSC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 14:02:58 -0400
Received: by mail-pd0-f174.google.com with SMTP id g10so6351670pdj.5
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 11:02:58 -0700 (PDT)
Date: Tue, 23 Sep 2014 19:02:55 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, kernel@stlinux.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 1/3] media: st-rc: move to using
 reset_control_get_optional
Message-ID: <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Srini,

On Mon, 22 Sep 2014, Srinivas Kandagatla wrote:

> This patch fixes a compilation error while building with the
> random kernel configuration.
> 
> drivers/media/rc/st_rc.c: In function 'st_rc_probe':
> drivers/media/rc/st_rc.c:281:2: error: implicit declaration of
> function 'reset_control_get' [-Werror=implicit-function-declaration]
>   rc_dev->rstc = reset_control_get(dev, NULL);
> 
> drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
> from integer without a cast [enabled by default]
>   rc_dev->rstc = reset_control_get(dev, NULL);

Is managing the reset line actually optional though? I can't test atm as I don't have
access to my board, but quite often if the IP's aren't taken out of reset reads / writes
to the perhpiheral will hang the SoC.

If managing the reset line isn't optional then I think the correct fix is to add
depends on RESET_CONTROLLER in the kconfig.

This will then do the right thing for randconfig builds as well.

regards,

Peter.

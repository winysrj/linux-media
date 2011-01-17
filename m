Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37958 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1AQIRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 03:17:11 -0500
Date: Mon, 17 Jan 2011 00:17:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firedtv: fix remote control with newer Xorg evdev
Message-ID: <20110117081703.GA22802@core.coreip.homeip.net>
References: <20110116093921.6275ac89@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110116093921.6275ac89@stein>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stefan,

On Sun, Jan 16, 2011 at 09:39:21AM +0100, Stefan Richter wrote:
> @@ -188,6 +189,7 @@ void fdtv_handle_rc(struct firedtv *fdtv
>  		return;
>  	}
>  
> -	input_report_key(fdtv->remote_ctrl_dev, code, 1);
> -	input_report_key(fdtv->remote_ctrl_dev, code, 0);
> +	input_report_key(idev, code, 1);

input_sync() is needed here as well - userspace is free to accumulate
device state between EV_SYN events.

> +	input_report_key(idev, code, 0);
> +	input_sync(idev);
>  }
> 

-- 
Dmitry

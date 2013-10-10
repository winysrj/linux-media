Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59876 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JJRZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 13:25:54 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so1351707eek.1
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 10:25:53 -0700 (PDT)
Message-ID: <5256E334.3090600@googlemail.com>
Date: Thu, 10 Oct 2013 19:26:12 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: hans.verkuil@cisco.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v4l2-ctrls: fix typo in header file media/v4l2-ctrls.h
References: <1381425692-5023-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1381425692-5023-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, there is no PATCH 2/2, this one is the only one. :)

Frank

Am 10.10.2013 19:21, schrieb Frank Schäfer:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  include/media/v4l2-ctrls.h |    2 +-
>  1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)
>
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 47ada23..16f7f26 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -571,7 +571,7 @@ static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
>  	mutex_lock(ctrl->handler->lock);
>  }
>  
> -/** v4l2_ctrl_lock() - Helper function to unlock the handler
> +/** v4l2_ctrl_unlock() - Helper function to unlock the handler
>    * associated with the control.
>    * @ctrl:	The control to unlock.
>    */


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0EDQGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 12:06:49 -0400
Received: by fxm10 with SMTP id 10so3380819fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 09:06:48 -0700 (PDT)
Date: Tue, 4 May 2010 18:06:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] IR/imon: remove dead IMON_KEY_RELEASE_OFFSET
Message-ID: <20100504160641.GZ29093@bicker>
References: <20100504122030.GX29093@bicker> <20100504140318.GA10813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504140318.GA10813@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 04, 2010 at 10:03:18AM -0400, Jarod Wilson wrote:
> @@ -1205,7 +1204,7 @@ static u32 imon_panel_key_lookup(u64 hw_code)
>  		if (imon_panel_key_table[i].hw_code == (code | 0xffee))
>  			break;
>  
> -	keycode = imon_panel_key_table[i % IMON_KEY_RELEASE_OFFSET].keycode;
> +	keycode = imon_panel_key_table[i].keycode;
>  
>  	return keycode;
>  }

There is still potentially a problem here because if we don't hit the 
break statement, then we're one past the end of the array.

regards,
dan carpenter


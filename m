Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:37239 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZEBHMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 03:12:18 -0400
Date: Sat, 2 May 2009 09:12:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@isely.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
    model
Message-ID: <20090502091211.2a26f09b@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0905012010220.15541@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
	<20090417223105.28b8957e@hyperion.delvare>
	<Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
	<20090418112519.774e0dae@hyperion.delvare>
	<20090418151625.254e466b@hyperion.delvare>
	<Pine.LNX.4.64.0904180842110.19718@cnc.isely.net>
	<20090423110038.59554982@hyperion.delvare>
	<Pine.LNX.4.64.0904230928410.3285@cnc.isely.net>
	<Pine.LNX.4.64.0905012010220.15541@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Sorry for not answering your previous post...

On Fri, 1 May 2009 20:30:48 -0500 (CDT), Mike Isely wrote:
> Jean:
> 
> I have another idea that I think you'll like.  I'm putting the finishing 
> touches on the patch right now.
> 
> What I have implements correct ir_video loading for the pvrusb2 driver.  
> It also includes a lookup table (though with only 1 entry right now) to 
> determine the proper I2C address and I use i2c_new_device() now instead 
> of i2c_new_probed_device().  I've also renamed things to be "ir_video" 
> everywhere instead of ir_kbd_i2c as was discussed.

This sounds really good. The more we know about cards, the less we have
to probe, the better.

> In particular the disable option is there like before, but now it's 
> called disable_autoload_ir_video.

Call me a nitpicker, but once again, there's nothing autoloading here
so this name is a little confusing.

> So far this is exactly what I was saying before.  But I'm also making 
> one more change: the disable_autoload_ir_video option default value will 
> - for now - be 1, i.e. everything above I just described starts off 
> disabled.  This means that the entire patch can be pulled _right_ _now_ 
> without breaking anything at all, because the outward behavior is still 
> unchanged.

Yes, this is correct, and will obviously make merging easier. Thanks
for coming up with this.

> Then, when you're ready to bring your stuff in, all you need to do is 
> include a 1-line change to pvrusb2-i2c-core.c to switch the default 
> value of disable_autoload_ir_video back to 0, which now enables all the 
> corresponding pvrusb2 changes that you need to avoid any breakage inside 
> my driver.  Just to be absolutely crystal clear, here's the change you 
> will be able to do once these changes are in:
> 
> diff -r 8d2e1361520c linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> --- a/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Fri May 01 20:23:39 2009 -0500
> +++ b/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Fri May 01 20:24:23 2009 -0500
> @@ -43,7 +43,7 @@
>  module_param_array(ir_mode, int, NULL, 0444);
>  MODULE_PARM_DESC(ir_mode,"specify: 0=disable IR reception, 1=normal IR");
>  
> +static int pvr2_disable_ir_video;
> -static int pvr2_disable_ir_video = 1;
>  module_param_named(disable_autoload_ir_video, pvr2_disable_ir_video,
>  		   int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(disable_autoload_ir_video,
> 
> So with all this, what I am setting up right now will cause no harm to 
> the existing situation, requires no actual messing with module options, 
> and once you're reading, just include the 1-line change above and you're 
> set.  There's no "race here", no gap in IR handling.

This is all fine with me. Well, at this point, pretty much everything
which pushes the ir-kbd-i2c conversion forward is fine with me, as it
seems to be kind of stuck. The theory was that we would use the 2.6.31
development cycle to merge lirc and then convert ir-kbd-i2c, however I
don't see much happening in this direction, while we're probably 5
weeks away from the next merge window or so.

Mauro, please pull Mike's pvrusb2-dev work as soon as he asks you to do
so. Then I'll rebase my own patch set and send it again.

Thanks,
-- 
Jean Delvare

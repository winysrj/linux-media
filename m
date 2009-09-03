Return-path: <linux-media-owner@vger.kernel.org>
Received: from ziczac-stoffe.de ([85.10.211.186]:4566 "EHLO
	mail.ziczac-stoffe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZICUAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 16:00:48 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.ziczac-stoffe.de (Postfix) with ESMTP id 5C4723E3A39
	for <linux-media@vger.kernel.org>; Thu,  3 Sep 2009 22:00:49 +0200 (CEST)
Received: from mail.ziczac-stoffe.de ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7Mk1l5Cbx7Z for <linux-media@vger.kernel.org>;
	Thu,  3 Sep 2009 22:00:36 +0200 (CEST)
Received: from gw.ziczac-stoffe.local (p54B3EEAC.dip.t-dialin.net [84.179.238.172])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "gw.ziczac-stoffe.local", Issuer "ziczac-stoffe.de Server CA" (verified OK))
	by mail.ziczac-stoffe.de (Postfix) with ESMTP id C4EE03E21EA
	for <linux-media@vger.kernel.org>; Thu,  3 Sep 2009 22:00:35 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gw.ziczac-stoffe.local (Postfix) with ESMTP id A8ED6403F
	for <linux-media@vger.kernel.org>; Thu,  3 Sep 2009 22:00:33 +0200 (CEST)
Received: from gw.ziczac-stoffe.local ([127.0.0.1])
	by localhost (gw.ziczac-stoffe.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQezA+OrU0Av for <linux-media@vger.kernel.org>;
	Thu,  3 Sep 2009 22:00:33 +0200 (CEST)
Date: Thu, 3 Sep 2009 22:00:32 +0200
From: Mario Neudeck <mario.neudeck@ziczac-stoffe.de>
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy T USB XXS
Message-ID: <20090903200032.GA15626@gw.ziczac-stoffe.local>
References: <20090903181736.GH14422@gw.ziczac-stoffe.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903181736.GH14422@gw.ziczac-stoffe.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

now I compiled and installed the newest v4l-driver, but the stick
doesnt work.
Does anyone have suggestions how to get the stick work?

Thanks for help,
Mario


On Thu, Sep 03, 2009 at 08:17:36PM +0200, Mario Neudeck wrote:
> Hello,
> 
> I have some trouble with a Cinergy T USB XXS stick. As described on
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_XXS the
> stick should work. But my device comes with USB-ID 0ccd:00ab and not
> with USB-ID 0ccd:0078 (linuxtv.org). 
> I'm using firmware dvb-usb-dib0700-1.10.fw.
> 
> The kernelmodul is loaded:
>  [223.409297] dib0700: loaded with support for 7 different device-types
> 
> The next step should loading the firmware like that:
>  [ 223.409638] dvb-usb: found a 'Terratec Cinergy T USB XXS' in cold
> state, will try to load a firmware.
> 
> But nothing happens. Because of that there is no /dev/dvb.
> 
> modinfo dvb_usb_dib0700 gives this information:
> ...
> filename:
> /lib/modules/2.6.26-2-openvz-686/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dib0700.ko
> ...
> 
> Does anyone have some information to get the stick work. Maybe it is
> unsupported because of the differnt USB-ID ?
> 
> Thanks for help,
> Mario
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

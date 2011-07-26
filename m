Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58317 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1GZOuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:50:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QlixR-0004Db-CP
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 16:50:05 +0200
Received: from support01.office.net1.cc ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 16:50:05 +0200
Received: from root by support01.office.net1.cc with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 16:50:05 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: Re: [PATCH] Fix regression introduced which broke the Hauppauge USBLive
 2
Date: Tue, 26 Jul 2011 17:47:27 +0300
Message-ID: <j0mk28$gul$2@dough.gmane.org>
References: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

На 24.7.2011 г. 04:17 ч., Devin Heitmueller написа:
> The following patch addresses the regression introduced in the cx231xx
> driver which stopped the Hauppauge USBLive2 from working.
>
> Confirmed working by both myself and the user who reported the issue
> on the KernelLabs blog (Robert DeLuca).
>

I can also confirm this patch works fine for me.

[  839.052752] cx231xx: Cx231xx Audio Extension initialized
[  850.221325] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  850.224774] cx231xx #0: cx231xx_init_audio_isoc: Starting ISO AUDIO 
transfers
[  851.150358] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4

It was not possible to capture audio from the device before that.


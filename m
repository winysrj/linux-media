Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64917 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaDQB14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 21:27:56 -0400
Received: by mail-vc0-f169.google.com with SMTP id ik5so12039973vcb.0
        for <linux-media@vger.kernel.org>; Wed, 16 Apr 2014 18:27:55 -0700 (PDT)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Help with SMS2270 @ linux-sunxi (A20 devices)
From: Roberto Alcantara <roberto@eletronica.org>
In-Reply-To: <20140416133419.7d0a1e9f@samsung.com>
Date: Wed, 16 Apr 2014 22:27:41 -0300
Cc: Sat <sattnag@aim.com>, linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D7EB0DA7-165F-4376-B708-02D10CDA427F@eletronica.org>
References: <DB7459DA-2266-4DF3-BBD6-3CB991F7738A@eletronica.org> <534E4489.6080909@aim.com> <20140416133419.7d0a1e9f@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bad news for me.

I will try to debug something about MTP despite I don’t know yet how to. 

I will let know about this guys.

Thank you !


Em 16/04/2014, à(s) 13:34, Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> 
> 
> I suspect that it is trying to load this device via smsdio driver, but
> I'm not sure.
> 
> Those MTP probe messages look weird to me. I suspect that it didn't even
> called the USB probing method for this device, but I'm not a MTP
> expert.
> 
> Regards,
> Mauro
> 
>>> 
>>> Best regards,
>>>  - Roberto
>>> 
>>> 
>>> root@awsom:/home/linaro# lsmod
>>> Module                  Size  Used by
>>> sunxi_cedar_mod        10284  0
>>> smsdvb                 13909  0
>>> smsusb                  8936  0
>>> smsmdtv                28266  2 smsdvb,smsusb
>>> disp_ump                 854  0
>>> mali_drm                2638  1
>>> mali                  113459  0
>>> ump                    56392  4 disp_ump,mali
>>> lcd                     3646  0


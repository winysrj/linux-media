Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:49038 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbZHEUWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 16:22:37 -0400
Received: by ywh13 with SMTP id 13so478459ywh.15
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 13:22:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79E6B7.5090408@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A739DD6.8030504@iol.it>
	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	 <4A79320B.7090401@iol.it>
	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
	 <4A79CEBD.1050909@iol.it>
	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
	 <4A79E07F.1000301@iol.it>
	 <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
	 <4A79E6B7.5090408@iol.it>
Date: Wed, 5 Aug 2009 16:22:36 -0400
Message-ID: <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 4:08 PM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> I don't know what the process is for uninstalling the mcentral.de
>> em28xx driver.  Probably involves removing that directory and
>> re-running depmod or something.
>
> ok, I run:
> $ sudo mv /lib/modules/2.6.28-14-generic/empia/ ~/temp
> $ sudo depmod -a
>
> then connected the TVtuner, Kaffeine identify the TV tuner and the
> video/audio is OK.
> And now IR send digit to text editor and Kaffeine.
>
> thanks
> Valerio

Great.  I'll get a PULL request issued so this can get into the
mainline.  Thanks for testing.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

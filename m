Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:40635 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZHETvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 15:51:04 -0400
Received: by yxe5 with SMTP id 5so423921yxe.33
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 12:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79E07F.1000301@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it>
	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	 <4A79320B.7090401@iol.it>
	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
	 <4A79CEBD.1050909@iol.it>
	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
	 <4A79E07F.1000301@iol.it>
Date: Wed, 5 Aug 2009 15:51:05 -0400
Message-ID: <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 3:41 PM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> Try running this:
>>
>> find /lib/modules/ -name "em28*"
<snip>

Yeah, that confirms it.  The files in /lib/modules/2.6.28-14-generic/
are conflicting with the reset of the v4l-dvb codebase.  Basically,
the mcentral.de em28xx driver is attempting to load but conflicts with
the videobuf implementation provided by v4l-dvb.

I don't know what the process is for uninstalling the mcentral.de
em28xx driver.  Probably involves removing that directory and
re-running depmod or something.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:53157 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760729AbZCaOeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 10:34:05 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2456259ywb.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 07:34:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D228EA.3090302@linuxtv.org>
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
	 <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
	 <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
	 <49D228EA.3090302@linuxtv.org>
Date: Tue, 31 Mar 2009 10:34:02 -0400
Message-ID: <412bdbff0903310734r3002e083j9c7f83bfc9855c7d@mail.gmail.com>
Subject: Re: XC5000 DVB-T/DMB-TH support
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: David Wong <davidtlwong@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 10:30 AM, Steven Toth <stoth@linuxtv.org> wrote:
> Hmm.
>
>>                priv->freq_hz = params->frequency - 1750000;
>
> Prior to reading this I would of sworn blind that we'd witnessed the XC5000
> working on DVB-T devices, it's been a while and now I'm doubting that
> belief.

Yeah, the code doesn't currently have DVB-T support.  If you specify
any modulation other than the VSB or QAM modulations, it returns
-EINVAL..

If I had a board and a generator, I could probably bring it up pretty quick.

Also, as I later told David in an off-list email, I believe I was
mistaken about the offset needing to be 1750000.  I think it should
actually be 2570000 for DVB-T.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

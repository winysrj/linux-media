Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33947 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZI1SFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 14:05:53 -0400
Received: by bwz6 with SMTP id 6so1457155bwz.37
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 11:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC0E7B0.3010409@gmail.com>
References: <4AC0D05D.4060304@gmail.com>
	 <829197380909280824q487c3effp64914d8430f16092@mail.gmail.com>
	 <4AC0E21F.1000301@gmail.com>
	 <829197380909280923r28452c44j610ffdcccf3f5d38@mail.gmail.com>
	 <4AC0E7B0.3010409@gmail.com>
Date: Mon, 28 Sep 2009 14:05:55 -0400
Message-ID: <829197380909281105p53315240t40e0609b80cf1905@mail.gmail.com>
Subject: Re: [PATCH 2/2] em28xx: Convert printks to em28xx_err and em28xx_info
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: rosset.filipe@gmail.com
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 28, 2009 at 12:43 PM, Filipe Rosset <rosset.filipe@gmail.com> wrote:
> Em 28-09-2009 13:23, Devin Heitmueller escreveu:
>>
>> Filipe,
>>
>> Your updated patch is going to effectively print dev->name twice.
>> Please look at the definition of em28xx_errdev() and resubmit an
>> updated patch that takes this into account.
>>
>> Thanks,
>>
>> Devin
>>
>
> Hi Devin,
>
> I now resend correct patch.
> Sorry for inconvenience.
> Thanks,
>
> Filipe

Hi Felipe,

Sorry, I'm not trying to be difficult, but could you please include
the SOB block in your final patch, as you did with your original
version?  This is required in order for it to be merged upstream.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

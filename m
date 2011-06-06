Return-path: <mchehab@pedra>
Received: from ns2011.yellis.net ([79.170.233.11]:35038 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1FFRQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:16:15 -0400
Message-ID: <4DED0BAC.6090400@anevia.com>
Date: Mon, 06 Jun 2011 19:17:32 +0200
From: Florent Audebert <florent.audebert@anevia.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: HVR-1300 analog inputs
References: <4DE65C6D.2060806@anevia.com>	<BANLkTi=zUfg9hAN8X9nrPEOMgtUzsKrbOw@mail.gmail.com>	<4DED0412.4030708@anevia.com> <BANLkTint7wHxBxc7ZQB4UohJD-7UE09mAQ@mail.gmail.com>
In-Reply-To: <BANLkTint7wHxBxc7ZQB4UohJD-7UE09mAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/06/2011 06:55 PM, Devin Heitmueller wrote:
> On Mon, Jun 6, 2011 at 12:45 PM, Florent Audebert
> <florent.audebert@anevia.com>  wrote:
>> Nonetheless, I have vertical lines when using s-video at MPEG device output
>> (more visible in white areas)[1].
>>
>> Reading from capture device is alright whether s-video (input=2) or
>> composite (input=1) is selected. I've tested it like this:
>
> So, if I understand you correctly, you're getting the lines when using
> the MPEG encoder but not the raw output?  This looks like the
> decoder's clamp control registers are not properly configured, which I
> would have assumed would occur regardless of whether the encoder was
> being used.

That's right. RAW output seems clean so far in all cases.

  - When selecting composite input, MPEG encoder output is clean
  - When selecting s-video input, MPEG encoder output have lines


Regards,

-- 
Florent AUDEBERT

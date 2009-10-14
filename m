Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54877 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778AbZJNNPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 09:15:09 -0400
Received: by fxm27 with SMTP id 27so11568642fxm.17
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 06:14:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD5AFA6.8080401@onelan.com>
References: <4AD591BB.80607@onelan.com>
	 <1255516547.3848.10.camel@palomino.walls.org>
	 <4AD5AFA6.8080401@onelan.com>
Date: Wed, 14 Oct 2009 09:14:32 -0400
Message-ID: <829197380910140614l1b7e299ev9bad4bbe96081918@mail.gmail.com>
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 7:01 AM, Simon Farnsworth
<simon.farnsworth@onelan.com> wrote:
> Andy Walls wrote:
>> Have your remote user read
>>
>> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
>>
>> and take any actions that seem appropriate/easy.
>>
> I'll try that again - they're grouching, because their TV is fine, and
> the same card in a Windows PC is also fine. It's just under Linux that
> they're seeing problems, so I may not be able to get them to co-operate.
>>
>> The in kernel mxl5005s driver is known to have about 3 dB worse
>> performance for QAM vs 8-VSB (Steven Toth took some measurements once).
>>
> Am I misunderstanding dmesg here? I see references to a Samsung S5H1409,
> not to an mxl5005s; if I've read the driver code correctly, I'd see a
> KERN_INFO printk for the mxl5005s when it comes up.

Simon, the HVR-1600 has both an s5h1409 and an mxl5005s - the s5h1409
is the digital demodulator and the mxl5005s is the tuner chip.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

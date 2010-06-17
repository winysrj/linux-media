Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:52998 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab0FQJvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 05:51:18 -0400
Received: by pxi12 with SMTP id 12so120073pxi.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 02:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
	<AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
	<20100616205745.GA22103@linux-m68k.org>
	<AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
Date: Thu, 17 Jun 2010 10:51:17 +0100
Message-ID: <AANLkTimRduresDdSlIgKkC3f0EVmVDae5flTv1EKccKR@mail.gmail.com>
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 17, 2010 at 10:03 AM, Pedro Côrte-Real <pedro@pedrocr.net> wrote:
> On Wed, Jun 16, 2010 at 9:57 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
>> Did you try kaffeine or w_scan?
>
> I did try both of those. kaffeine I haven't been able to get to work
> at all and w_scan found the frequency but not the channels, much like
> scan. I'll try those again.

I tried both those again with pretty much the same results. Here is kaffeine:

kaffeine(2196) DvbScanFilter::timerEvent: timeout while reading
section; type = 0 pid = 0
kaffeine(2196) DvbScanFilter::timerEvent: timeout while reading
section; type = 2 pid = 17

And here is "w_scan -c PT":

842000: (time: 02:44) (time: 02:47) signal ok:
	QAM_AUTO f = 842000 kHz I999B8C999D999T999G999Y999
Info: NIT(actual) filter timeout
850000: (time: 03:02)
858000: (time: 03:05)
tune to: QAM_AUTO f = 842000 kHz I999B8C999D999T999G999Y999
(time: 03:08) Info: PAT filter timeout
Info: SDT(actual) filter timeout
Info: NIT(actual) filter timeout

I wonder if the PT setting here is correct for DVB-T, but it does find
something in the correct frequency but then does a timeout just like
scan.

Pedro

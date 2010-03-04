Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:33933 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0CDLOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 06:14:22 -0500
Received: by ewy20 with SMTP id 20so1614634ewy.21
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 03:14:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8F347E.2010206@gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
	 <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
	 <4B8F347E.2010206@gmail.com>
Date: Thu, 4 Mar 2010 11:14:20 +0000
Message-ID: <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Pedro Ribeiro <pedrib@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 March 2010 04:18, Mauro Carvalho Chehab <maurochehab@gmail.com> wrote:
> Devin Heitmueller wrote:
>> On Wed, Mar 3, 2010 at 8:00 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>>> Its working very well, thanks.
>>>
>>> Can you please tell me if its going to be pushed to .33 stable? And
>>> should I close the kernel bug?
>>
>> It's in Mauro's PULL request for 2.6.34-rc1.  It's marked "normal"
>> priority so it likely won't get pulled into stable.  It was a
>> non-trivial restructuring of the code, so doing a minimal fix that
>> would be accepted by stable is unlikely.
>
> The kernel bug should be closed, as this patch has already fixed and
> sent upstream.
>>
>> Devin
>>
>
>
> --
>
> Cheers,
> Mauro
>

Devin, I noticed that your solution does not alter the remote query
interval from 50 msec. It works, but it is not as effective as my hard
hack because I still get interference every once in a while when the
DVB adapter is connected.

I can't tell you exactly when and how it happens, because it seems
rather random - but it is much better than previously though.

Regards,
Pedro

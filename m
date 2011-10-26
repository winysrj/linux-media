Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:48820 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1JZTpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 15:45:45 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9QJjh79021535
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:45:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id CB4F61E01A6
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:45:42 -0400 (EDT)
Message-ID: <4EA86366.1020906@lockie.ca>
Date: Wed, 26 Oct 2011 15:45:42 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon signal strength
References: <4EA78E3C.2020308@lockie.ca> <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
In-Reply-To: <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/26/11 04:15, Devin Heitmueller wrote:
> On Wed, Oct 26, 2011 at 12:36 AM, James<bjlockie@lockie.ca>  wrote:
>> My signal strength is always above 0 but when I use -H, it is 0%.
>> Does that mean my signal strength is<0%?
>> Maybe femon should report 0.x%.
>>
>> $ femon
>> FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
>> status SCVYL | signal 00b9 | snr 00b9 | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>> $ femon -H
>> FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
>> status SCVYL | signal   0% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
>>
>> Is it normal to have<0% signal strength and still get reception?
> For this demodulator, this is normal.  The issue is there is no set
> standard for the way in which signal level and SNR are reported in the
> linux DVB API, and as a result there are numerous different formats.
How many different formats are there (do I have to go through the archive)?
Would it be feasable to change femon to handle different formats?

femon was written by Johannes Stezenbach (see DVB-apps/szap/femon.c ).

I'm going to try to change the code to at least work with my FE. :-)
> The format the s5h1409 demodulator driver delivers it doesn't match
> the demodulator that the person who wrote femon had available to
> him/her (the s5h1409 delivers both fields in 0.1dB increments, while
> whatever demod the femon author had to test with expected signal to be
> 0-65535 and SNR to be in 1/256 increments).
>
> In other words if you have an SNR of 30.0 dB, femon sees 0x012c, which
> it treats as a percentage of 0xffff which is 0.00457%, which gets
> rendered as 0%.
>
> Unfortunately, the driver community has never been able to form a
> consensus on how the data should be reported, so you cannot really
> argue the s5h1409 driver is "doing it wrong" (numerous other drivers
> report in the same manner as the s5h1409).  You can read the mailing
> list archive for the gory history.  It really is a fine example of the
> failure associated with "design by committee".
>
> Devin
>


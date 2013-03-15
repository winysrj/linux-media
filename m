Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49794 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3COI46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 04:56:58 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so1378214eaf.14
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2013 01:56:56 -0700 (PDT)
Message-ID: <5142F063.5000007@gmail.com>
Date: Fri, 15 Mar 2013 10:56:51 +0100
From: Benjamin Schindler <beschindler@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: msp3400 problem in linux-3.7.0
References: <51410709.5040805@gmail.com> <201303140757.10555.hverkuil@xs4all.nl> <51417899.2070201@gmail.com> <201303140844.37378.hverkuil@xs4all.nl>
In-Reply-To: <201303140844.37378.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just tried to apply the patch, but it does not apply cleanly:

metis linux # patch -p1 < /home/benjamin/Downloads/bttv-patch.txt
patching file drivers/media/pci/bt8xx/bttv-driver.c
Hunk #1 FAILED at 2007.
Hunk #2 FAILED at 2024.
Hunk #3 succeeded at 4269 with fuzz 2 (offset 34 lines).
Hunk #4 succeeded at 4414 (offset 34 lines).
2 out of 4 hunks FAILED -- saving rejects to file 
drivers/media/pci/bt8xx/bttv-driver.c.rej
patching file drivers/media/pci/bt8xx/bttvp.h

I then tried applying it manually, which I think worked. But it did not 
fix the problem. Given that the patch did not apply cleanly, may be I 
should either use the media git tree or wait for 3.10.

I just realized that this was on a 3.7.10 kernel (not 3.7.0, but that 
probably does not make much of a difference)

Regards
Benjamin

On 14.03.2013 08:44, Hans Verkuil wrote:
> On Thu March 14 2013 08:13:29 Benjamin Schindler wrote:
>> Hi Hans
>>
>> Thank you for the prompt response. I will try this once I'm home again.
>> Which patch is responsible for fixing it? Just so I can track it once it
>> lands upstream.
>
> There is a whole series of bttv fixes that I did that will appear in 3.10.
>
> But the patch that is probably responsible for fixing it is this one:
>
> http://git.linuxtv.org/media_tree.git/commit/76ea992a036c4a5d3bc606a79ef775dd32fd3daa
>
> I say 'probably' because I am not 100% certain that that is the main fix.
> I'm 99% certain, though :-)
>
> As mentioned, it was part of a much longer patch series, so there may be other
> patches involved in this particular problem, but I don't think so.
>
> If you can perhaps test just that single patch then that would be useful
> information. If that fixes the problem then that's a candidate for 'stable'
> kernels.
>
>> I have one more question - the wiki states the the WinTV-HVR-5500 is not
>> yet supported (as of June 2011) - is there an update on this? It's the
>> only DVB-C card I can buy in the local stores here
>
> No idea. I do V4L2, not DVB :-) Hopefully someone else knows.
>
> Regards,
>
> 	Hans
>


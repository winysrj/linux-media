Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:26705 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZDACed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 22:34:33 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3343826rvb.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 19:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903311844ye3323fbh1cc633cea4216149@mail.gmail.com>
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
	 <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
	 <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
	 <49D228EA.3090302@linuxtv.org>
	 <412bdbff0903310734r3002e083j9c7f83bfc9855c7d@mail.gmail.com>
	 <15ed362e0903311838w19c03f37ob9e893d35ea5cd92@mail.gmail.com>
	 <412bdbff0903311844ye3323fbh1cc633cea4216149@mail.gmail.com>
Date: Wed, 1 Apr 2009 10:34:31 +0800
Message-ID: <15ed362e0903311934h6e6bbbc5q70971ee4c0dfaaa8@mail.gmail.com>
Subject: Re: XC5000 DVB-T/DMB-TH support
From: David Wong <davidtlwong@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 1, 2009 at 9:44 AM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Tue, Mar 31, 2009 at 9:38 PM, David Wong <davidtlwong@gmail.com> wrote:
>> Thanks Devin. The demod locks after using -2750000.
>>
>> David.
>
> That's great news.  If you send me a patch (including your SOB), I
> will put it into the xc5000 patch series I am putting together this
> week.
>
> Regards,
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

No problem. But how about frequency compensation value for DTV7?
We know DTV6 and DTV8 settings now, just DTV7 is missing for FE_OFDM.

David

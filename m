Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:33976 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZFBGCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 02:02:03 -0400
Received: by bwz22 with SMTP id 22so7902477bwz.37
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2009 23:02:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905262106.03697.domi.dumont@free.fr>
References: <eaf6cbc30905252243m2d6e1537vd255e49f289c0f33@mail.gmail.com>
	 <200905262106.03697.domi.dumont@free.fr>
Date: Tue, 2 Jun 2009 08:56:11 +0300
Message-ID: <eaf6cbc30906012256j5ab600e6wffa5f315c076213a@mail.gmail.com>
Subject: Re: Problem with SCM/Viaccess CAM
From: Tomer Barletz <barletz@gmail.com>
To: Dominique Dumont <domi.dumont@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dominique,
I've tried to increase the time-out period from 5 to 10 seconds (as it
is with current source), but with no success.
Did your patch involved any other changes besides this one? How can I
obtain your patch? Did you changed dvb_ca_en50221.c only, or were
there any other files changed?
I know that my kernel is slightly old ;), but it is currently not
feasible for me to upgrade.

Thanks,
Tomer

On Tue, May 26, 2009 at 10:06 PM, Dominique Dumont <domi.dumont@free.fr> wrote:
> Le Tuesday 26 May 2009 07:43:15 Tomer Barletz, vous avez écrit :
>> Hi,
>> When inserting a SCM/Viaccess CAM, I get the following message:
>> dvb_ca adapter 0: DVB CAM did not respond :(
>>
>> According to this:
>> http://linuxtv.org/hg/v4l-dvb/file/142fd6020df3/linux/Documentation/dvb/ci.
>>txt this CAM should work.
>>
>> I'm using kernel 2.6.10.
>
> SCM CAMs are very slow to start up. I've submitted a patch to work-around this
> issue a few years ago. IIRC, this was around 2.6.14.
>
> So you should upgrade your kernel
>
> HTH
>
>

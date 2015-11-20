Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:52006 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbbKTPfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 10:35:21 -0500
Subject: Re: PID filter testing
To: Antti Palosaari <crope@iki.fi>,
	=?UTF-8?Q?Honza_Petrou=c5=a1?= <jpetrous@gmail.com>
References: <564EFD40.8050504@southpole.se>
 <CAJbz7-2=-ufqdE0YyPUAhV+UybMsmEv7=FuFhrn6o9G7yvXZOg@mail.gmail.com>
 <564F2D77.9080301@southpole.se> <564F3123.8040109@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <564F3DB6.2000804@southpole.se>
Date: Fri, 20 Nov 2015 16:35:18 +0100
MIME-Version: 1.0
In-Reply-To: <564F3123.8040109@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> hmm, that is null pid for padding ts to correct size IIRC. Take into
> account that some pid filters / bridges automatically filter it out.
> Usually it is there though.
>
> So it is not very good pid to test. If you want test some pid which is
> always there look those mandatory pids which are pids numbered near 0.
>
> regards
> Antti
>

When I hard code the rtl2833 external pid filter I am able to get only 
that pid. The inverse case also works as that is the default. Anyway I 
just want some tool that I can use from command line that can toggle 
pids somewhat dynamically. To bad there seems to be no ready available 
tool for that.

Adding pid selection to dvbv5-zap in monitor mode looks to be the best 
way forward.

MvH
Benjamin Larsson

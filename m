Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4660 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZCLXSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 19:18:14 -0400
Message-ID: <49B99828.3090002@linuxtv.org>
Date: Thu, 12 Mar 2009 19:18:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Fwd: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
  video_open
References: <200902241700.56099.jarod@redhat.com>	 <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com> <1236899033.3261.7.camel@palomino.walls.org>
In-Reply-To: <1236899033.3261.7.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2009-03-12 at 16:24 -0400, Michael Krufky wrote:
>   
>> Can we have this merged into -stable?  Jarod Wilson sent this last
>> month, but he left off the cc to stable@kernel.org
>>
>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>     
>
> Mike,
>
> A version of this is already in the v4l-dvb hg development repository:
>
> hg log -vp --limit 1 linux/drivers/media/video/cx23885/cx23885-417.c
> hg log -vp --limit 2 linux/drivers/media/video/cx23885/cx23885-video.c 
>
> I helped Mark work through the solution: I coded some of it, he coded
> some of it and he also tested it.
>
> Regards,
> Andy

I'm aware of that, Andy -- That's why I am sending this off to the 
-stable team for 2.6.27.y

Thanks & regards,

Mike

Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57901 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1CNBPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 21:15:20 -0400
References: <AANLkTi=RNXdb6BSLQL74NA9XMrN9mj6CNYvZgycSCQ9n@mail.gmail.com> <AANLkTinyJOVQEurOUdibvTfTNLRCWEJi_GX8=bodK4c=@mail.gmail.com> <AANLkTikCX8S=Q0=06ggw+qVAYRh=56ch3rRduyN0G7W5@mail.gmail.com> <AANLkTimVnmX6Bqk=wqB6g48M_JJ99tO=a7rVtQGcz-34@mail.gmail.com>
In-Reply-To: <AANLkTimVnmX6Bqk=wqB6g48M_JJ99tO=a7rVtQGcz-34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Problem with saa7134: Asus Tiger revision 1.0, subsys 1043:4857
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 13 Mar 2011 21:15:29 -0400
To: Jason Hecker <jwhecker@gmail.com>, linux-media@vger.kernel.org
Message-ID: <707cd595-bc97-4f8f-b478-3221539e8739@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jason Hecker <jwhecker@gmail.com> wrote:

>I seem to have fixed the problem for now.  It's the hoary old problem
>of Mythtv's backend coming up and accessing the cards before the
>firmware has loaded onto the cards.  Adding in a startup delay to
>myth-backend's init script has solved the problem, for now.  The
>firmware seems to load now on Mythbuntu 10.04 without a problem.
>
>Is there some way to put a lock in the driver or even speed up the
>process of loading the firmware with some command line arguments when
>the saa7134 driver is loaded?
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

The ivtv and cx18 driver have that sort of logic in them.  Look for init_on_first_open and serialized_open functions that set some firmware loading related bit flags.

I'm not sure what saa7134 does, but devloping a patch to add something similar shouldn't be rocket science for anyone with time, test hardware, and motivation.

-Andy

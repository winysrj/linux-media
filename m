Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc4-s14.bay0.hotmail.com ([65.54.190.216]:33512 "EHLO
	bay0-omc4-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbaDGKtZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Apr 2014 06:49:25 -0400
Message-ID: <BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Pawel Osciak <pawel@osciak.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: videobuf2-vmalloc suspect for corrupted data
Date: Mon, 7 Apr 2014 16:19:25 +0530
In-Reply-To: <CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com>
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>,<CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thanks for the quick response.

> Is it possible that your userspace is not always queuing the same
> userptr memory areas with the same v4l2_buffer index values?
No, userptr is always consistent with the index.
In fact, when we dump the captured buffer (Transport Stream) in this case, kernel space data and user-space are different.
When that TS is played, macroblocks are observed from user-space and not from the kernel space dump.
Although, user-space bad data is random, but, I have never seen kernel space dumped TS as bad.

> In other words, if you have 2 buffers in use, under userspace mapping
> at addr1 and addr2, if you queue addr1 with index=0 and addr2 with
> index=1 initially,
> you should always keep queuing addr1 with index=0 and never 1, etc.
Yeah! this is the same rule which is being followed.

> Also, what architecture are you running this on?
ARM Cortex A9 SMP

Regards,
Divneil 		 	   		  
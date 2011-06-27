Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59788 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab1F0JXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 05:23:13 -0400
Received: by gyh3 with SMTP id 3so1752635gyh.19
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2011 02:23:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110622161256.57a663da@bike.lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
	<BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
	<BANLkTi=gLkmuheH0aCwx=7-DuxDH3q769w@mail.gmail.com>
	<20110616092726.024701c9@bike.lwn.net>
	<BANLkTikO-oRJXgqkL557d9RZ6PMBFTzVCg@mail.gmail.com>
	<20110622161256.57a663da@bike.lwn.net>
Date: Mon, 27 Jun 2011 17:23:12 +0800
Message-ID: <BANLkTimQJdv+UO_LvLVHBJB80xeHLKPHxg@mail.gmail.com>
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/23 Jonathan Corbet <corbet@lwn.net>:
> [Sorry, I'm just now recovering from one of those
> total-loss-of-inbox-control episodes...]
>
> On Fri, 17 Jun 2011 11:11:33 +0800
> Kassey Lee <kassey1216@gmail.com> wrote:
>
>>      the problem is:
>>      when we stop CCIC, and then switch to another format.
>>      at this stage, actually, CCIC DMA is not stopped until the
>> transferring frame is done. this will cause system hang if we start
>> CCIC again with another format.
>
> OK, I've never encountered that.  The use case I'm coding for (OLPC)
> doesn't involve a whole lot of format changes; generally they pick a
> format for their record activity based on what works best on the display
> side and stick with it.

  that is different with our stress test case.


>
>>      from your logic, when stop DMA, you are test the EOF/SOF, so I
>> wonder why you want to do this ?
>>      and is your test will stop CCIC and start CCIC frequently  ?
>
> I wanted a way to know whether DMA was active or not; the idea was that an
> SOF indicates that things are starting, EOF says that it's done.  Are you
> saying that there can be DMA active in the period after an EOF when the
> subsequent SOF has not been received?
this is OK if we are streaming data.

but the point is CCIC DMA won't stop even we stop CCIC until the
transferring frame is done.

>
> Thanks,
>
> jon
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.

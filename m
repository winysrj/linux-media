Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39617 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab1FQDLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 23:11:34 -0400
Received: by ywe9 with SMTP id 9so1086246ywe.19
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 20:11:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110616092726.024701c9@bike.lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
	<BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
	<BANLkTi=gLkmuheH0aCwx=7-DuxDH3q769w@mail.gmail.com>
	<20110616092726.024701c9@bike.lwn.net>
Date: Fri, 17 Jun 2011 11:11:33 +0800
Message-ID: <BANLkTikO-oRJXgqkL557d9RZ6PMBFTzVCg@mail.gmail.com>
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

2011/6/16 Jonathan Corbet <corbet@lwn.net>:
> On Thu, 16 Jun 2011 11:12:03 +0800
> Kassey Lee <kassey1216@gmail.com> wrote:
>
>>       2) for mcam_ctlr_stop_dma implementation, I guess you know
>> something about the silicon limitation,  but we found it can not pass
>> our stress test(1000 times capture test, which will switch format
>> between JPEG and YUV again and again).
>>        our solution is :
>>        stop the ccic controller and wait for about one frame transfer
>> time, and the stop the sensor.
>>        this passed our stress test. for your info.
>
> Actually, I know very little that's not in the datasheet.  Are you telling
> me that there are hardware limitations that aren't documented, and that
> the datasheet is not a 100% accurate description of what's going on?  I'm
> *shocked* I tell you!
>
> (For the record, with both Cafe and Armada 610, I've found the hardware to
> be more reasonable and in accord with the documentation than with many
> others.)
>
> In any case, I don't know about the limitation you're talking about here,
> could you elaborate a bit?  For stress testing I've run video capture for
> weeks at a time, so obviously you're talking about something else.  Sounds
> like something I need to know?
hi, Jon:
     the problem is:
     when we stop CCIC, and then switch to another format.
     at this stage, actually, CCIC DMA is not stopped until the
transferring frame is done. this will cause system hang if we start
CCIC again with another format.
 we've ask silicon design to add CCIC DMA stop/start controller bit.

     from your logic, when stop DMA, you are test the EOF/SOF, so I
wonder why you want to do this ?
     and is your test will stop CCIC and start CCIC frequently  ?
     thanks
>
>>        3) for videoubuf2, will you use videoubuf2 only or combined
>> with soc-camera ? when can your driver for videoubuf2 ready ?
>
> Videobuf2 only.  To be honest, I've never quite understood what soc-camera
> buys.  If there's a reason to do a switch, it could be contemplated - but
> remember that Cafe is not an SoC device.
>
> The vb2 driver is working now in vmalloc mode, which is probably what Cafe
> will need forever.  I do plan to add dma-contig, and, probably, dma-sg
> support in the very near future.  If you want, I can post the vmalloc
> version later today; I just want to make one more pass over it first.
>
could you please share the vmalloc way to me ?
and if the dma-contig is OK, I'm glad to verify on our platform.
as to test USERPTR, we are using a PMEM to get phy-contig memory in
user space, and then QBUF to driver.

>>        4) the point is: ccic and sensor driver should be independent,
>> and support two CCIC controller.
>
> No disagreement there.  I believe that two controllers should work now -
> though there's probably a gotcha somewhere since it's not actually been
> tried.
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

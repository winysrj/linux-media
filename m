Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51320 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHQTaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Aug 2014 15:30:52 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so6420769pab.1
        for <linux-media@vger.kernel.org>; Sun, 17 Aug 2014 12:30:51 -0700 (PDT)
Message-ID: <53F10296.8080905@gmail.com>
Date: Mon, 18 Aug 2014 04:29:26 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 4/4] pt3: add support for Earthsoft PT3 ISDB-S/T receiver
 card
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com> <1405352627-22677-2-git-send-email-tskd08@gmail.com> <1405352627-22677-3-git-send-email-tskd08@gmail.com> <1405352627-22677-4-git-send-email-tskd08@gmail.com> <1405352627-22677-5-git-send-email-tskd08@gmail.com> <20140815131725.6451cbf9.m.chehab@samsung.com>
In-Reply-To: <20140815131725.6451cbf9.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年08月16日 01:17, Mauro Carvalho Chehab wrote:
..........
>> +++ b/drivers/media/pci/pt3/pt3.c
..........
>> +static int pt3_fetch_thread(void *data)
>> +{
>> +	struct pt3_adapter *adap = data;
>> +
>> +#define PT3_FETCH_DELAY (10 * 1000)
>> +#define PT3_INITIAL_DISCARD_BUFS 4
>> +
>> +	pt3_init_dmabuf(adap);
>> +	adap->num_discard = PT3_INITIAL_DISCARD_BUFS;
>> +
>> +	dev_dbg(adap->dvb_adap.device,
>> +		"PT3: [%s] started.\n", adap->thread->comm);
>> +	while (!kthread_should_stop()) {
>> +		pt3_proc_dma(adap);
>> +		usleep_range(PT3_FETCH_DELAY, PT3_FETCH_DELAY + 2000);
>> +	}
>> +	dev_dbg(adap->dvb_adap.device,
>> +		"PT3: [%s] exited.\n", adap->thread->comm);
>> +	adap->thread = NULL;
>> +	return 0;
>> +}
> 
> Why do you need a thread here? Having a thread requires some special
> care, as you need to delete it before suspend, restore at resume
> (if active) and be sure that it was killed at device removal.
> 
> I'm not seeing any of those things on this driver.

PT3 is a dumb device that lacks interrupt,
so the driver has to poll the DMA buffers regularly to know if
a DMA has finished.

I forgot to clean up the thread in remove() and will add it in the v2.
As with suspend/resume, I can add a check of freezing() like in
dvb_frontend.c::dvb_frontend_thread(), but if I remember right,
I had read before that someone pointed out that
the suspend/resume of DVB is not supported by DVB core,
and not many of other drivers seem to support it either,
so I thought I could omit this feature and rely on module re-probing.
Should I implement power management ops and set them to .driver.pm?

Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F391FC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 19:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEF0B218AF
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 19:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfBATNI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 14:13:08 -0500
Received: from mga18.intel.com ([134.134.136.126]:49964 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfBATNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 14:13:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 11:13:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,549,1539673200"; 
   d="scan'208";a="315596925"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga006.fm.intel.com with ESMTP; 01 Feb 2019 11:13:06 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 1 Feb 2019 11:13:06 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.2]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.103]) with mapi id 14.03.0415.000;
 Fri, 1 Feb 2019 11:13:06 -0800
From:   "Mani, Rajmohan" <rajmohan.mani@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Zhi@paasikivi.fi.intel.com" <Zhi@paasikivi.fi.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: RE: [PATCH] media: staging/intel-ipu3: Implement lock for stream
 on/off operations
Thread-Topic: [PATCH] media: staging/intel-ipu3: Implement lock for stream
 on/off operations
Thread-Index: AQHUuCOItqk09SukTkm5qxVbw0DkOqXICeuAgAACepCAA6IgAP//oZBw
Date:   Fri, 1 Feb 2019 19:13:05 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A599B3259B7@fmsmsx122.amr.corp.intel.com>
References: <20190129222736.6216-1-rajmohan.mani@intel.com>
 <20190130085901.w2ogdoax7t4yfyj6@paasikivi.fi.intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A599B325222@fmsmsx122.amr.corp.intel.com>
 <20190201163655.ufrazkvsabsp6gmv@paasikivi.fi.intel.com>
In-Reply-To: <20190201163655.ufrazkvsabsp6gmv@paasikivi.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTdjODI1MjMtMGI1Yy00NDc1LTkxMWUtY2UwZmE0YTdjNmQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTnVzSzBCaXpVQ0xHbnNKbG5mRWVTME5YKzZnZGtmQ2EyVFhtR3N0bFBGVHF5RFgyUEppZUZVWXFYT1pqQUZvcyJ9
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

> Subject: Re: [PATCH] media: staging/intel-ipu3: Implement lock for stream
> on/off operations
> 
> Hi Raj,
> 
> On Wed, Jan 30, 2019 at 05:17:15PM +0000, Mani, Rajmohan wrote:
> > Hi Sakari,
> >
> > > -----Original Message-----
> > > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > > Sent: Wednesday, January 30, 2019 12:59 AM
> > > To: Mani, Rajmohan <rajmohan.mani@intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org>; linux-media@vger.kernel.org;
> > > devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Laurent
> > > Pinchart <laurent.pinchart@ideasonboard.com>; Jacopo Mondi
> > > <jacopo@jmondi.org>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > > Bingbu <bingbu.cao@intel.com>; Zhi@paasikivi.fi.intel.com; Zhi, Yong
> > > <yong.zhi@intel.com>; hverkuil@xs4all.nl; tfiga@chromium.org
> > > Subject: Re: [PATCH] media: staging/intel-ipu3: Implement lock for
> > > stream on/off operations
> > >
> > > Hi Rajmohan,
> > >
> > > On Tue, Jan 29, 2019 at 02:27:36PM -0800, Rajmohan Mani wrote:
> > > > Currently concurrent stream off operations on ImgU nodes are not
> > > > synchronized, leading to use-after-free bugs (as reported by KASAN).
> > > >
> > > > [  250.090724] BUG: KASAN: use-after-free in
> > > > ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu] [  250.090726] Read of
> > > > size 8 at addr ffff888127b29bc0 by task yavta/18836 [  250.090731]
> > > > Hardware
> > > > name: HP Soraka/Soraka, BIOS Google_Soraka.10431.17.0 03/22/2018 [
> > > 250.090732] Call Trace:
> > > > [  250.090735]  dump_stack+0x6a/0xb1 [  250.090739]
> > > > print_address_description+0x8e/0x279
> > > > [  250.090743]  ? ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu] [
> > > > 250.090746]  kasan_report+0x260/0x28a [  250.090750]
> > > > ipu3_dmamap_free+0xc5/0x116 [ipu3_imgu] [  250.090754]
> > > > ipu3_css_pool_cleanup+0x24/0x37 [ipu3_imgu] [  250.090759]
> > > > ipu3_css_pipeline_cleanup+0x61/0xb9 [ipu3_imgu] [  250.090763]
> > > > ipu3_css_stop_streaming+0x1f2/0x321 [ipu3_imgu] [  250.090768]
> > > > imgu_s_stream+0x94/0x443 [ipu3_imgu] [  250.090772]  ?
> > > > ipu3_vb2_buf_queue+0x280/0x280 [ipu3_imgu] [  250.090775]  ?
> > > > vb2_dma_sg_unmap_dmabuf+0x16/0x6f [videobuf2_dma_sg] [
> > > > 250.090778]
> > > ?
> > > > vb2_buffer_in_use+0x36/0x58 [videobuf2_common] [  250.090782]
> > > > ipu3_vb2_stop_streaming+0xf9/0x135 [ipu3_imgu]
> > > >
> > > > Implemented a lock to synchronize imgu stream on / off operations
> > > > and the modification of streaming flag (in struct imgu_device), to
> > > > prevent these issues.
> > > >
> > > > Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > >
> > > > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > > > ---
> > > >  drivers/staging/media/ipu3/ipu3-v4l2.c | 6 ++++++
> > > >  drivers/staging/media/ipu3/ipu3.c      | 3 +++
> > > >  drivers/staging/media/ipu3/ipu3.h      | 4 ++++
> > > >  3 files changed, 13 insertions(+)
> > > >
> > > > diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c
> > > > b/drivers/staging/media/ipu3/ipu3-v4l2.c
> > > > index c7936032beb9..cf7e917cd0c8 100644
> > > > --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> > > > +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> > > > @@ -507,12 +507,15 @@ static int ipu3_vb2_start_streaming(struct
> > > vb2_queue *vq, unsigned int count)
> > > >  			goto fail_stop_pipeline;
> > > >  	}
> > > >
> > > > +	mutex_lock(&imgu->streaming_lock);
> > > > +
> > >
> > > You appear to be using imgu_device.lock (while searching buffers to
> > > queue to the device) as well as imgu_video_device.lock (qbuf, dqbuf)
> > > to serialise access to imgu_video_device.buffers list.
> >
> > Ack
> >
> > > The two locks may be acquired at the same time but each by different
> > > processes. That needs to be addressed, but probably not in this
> > > patch.
> > >
> >
> > The node specific locks will be used by different processes and all of
> > these processes will be competing commonly (and successfully) for the
> imgu_device lock.
> > I will look into this more.
> >
> > > I wonder if it'd be more simple to use imgu->lock here instead of
> > > adding a new one.
> > >
> >
> > Extending imgu->lock here, does not work in this case, as
> > imgu_queue_buffers() will be stuck acquiring imgu->lock, which was
> > already acquired by imgu_s_stream() through ipu3_vb2_start_streaming().
> 
> You could move acquiring the lock out of these functions. It would also seem
> that there is device-wide streaming state etc. information to which the access
> should also be serialised. Currently it's relying on the node-specific lock only
> which does not help.
> 

Ack. Let me look into this more.

> Can you grab the lock right after dev_dbg() line in the function?
> 

In order to reduce the amount of code that's run with the lock held,
I placed the lock here.

Do you see issues in calls to imgu_sd subdevs and media_pipeline_start(),
without the lock being held?

> The lock should be also acquired before testing imgu->streaming in
> ipu3_vb2_buf_queue() to make sure it won't change in the meantime.
> 

I thought about this and decided against this since the odds of multiple
instances of applications, each of which using a single node simultaneously
are less, in a typical camera use case.
Please confirm if you see significant issues without the lock here, so we can
add the lock here as well.

> >
> > > >  	/* Start streaming of the whole pipeline now */
> > > >  	dev_dbg(dev, "IMGU streaming is ready to start");
> > > >  	r = imgu_s_stream(imgu, true);
> > > >  	if (!r)
> > > >  		imgu->streaming = true;
> > > >
> > > > +	mutex_unlock(&imgu->streaming_lock);
> > > >  	return 0;
> > > >
> > > >  fail_stop_pipeline:
> > > > @@ -543,6 +546,8 @@ static void ipu3_vb2_stop_streaming(struct
> > > vb2_queue *vq)
> > > >  		dev_err(&imgu->pci_dev->dev,
> > > >  			"failed to stop subdev streaming\n");
> > > >
> > > > +	mutex_lock(&imgu->streaming_lock);
> > > > +
> > > >  	/* Was this the first node with streaming disabled? */
> > > >  	if (imgu->streaming && ipu3_all_nodes_streaming(imgu, node)) {
> > > >  		/* Yes, really stop streaming now */ @@ -552,6 +557,7 @@
> > > static
> > > > void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
> > > >  			imgu->streaming = false;
> > > >  	}
> > > >
> > > > +	mutex_unlock(&imgu->streaming_lock);
> > > >  	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
> 
> I'd also call ipu3_return_all_buffers() before releasing the lock: in principle the
> user may have queued new buffers on the devices before the driver marks the
> buffers as faulty.
> 
> > >
> > > >  	media_pipeline_stop(&node->vdev.entity);
> > > >  }
> > > > diff --git a/drivers/staging/media/ipu3/ipu3.c
> > > > b/drivers/staging/media/ipu3/ipu3.c
> > > > index d521b3afb8b1..2daee51cd845 100644
> > > > --- a/drivers/staging/media/ipu3/ipu3.c
> > > > +++ b/drivers/staging/media/ipu3/ipu3.c
> > > > @@ -635,6 +635,7 @@ static int imgu_pci_probe(struct pci_dev
> *pci_dev,
> > > >  		return r;
> > > >
> > > >  	mutex_init(&imgu->lock);
> > > > +	mutex_init(&imgu->streaming_lock);
> > > >  	atomic_set(&imgu->qbuf_barrier, 0);
> > > >  	init_waitqueue_head(&imgu->buf_drain_wq);
> > > >
> > > > @@ -699,6 +700,7 @@ static int imgu_pci_probe(struct pci_dev
> *pci_dev,
> > > >  	ipu3_css_set_powerdown(&pci_dev->dev, imgu->base);
> > > >  out_mutex_destroy:
> > > >  	mutex_destroy(&imgu->lock);
> > > > +	mutex_destroy(&imgu->streaming_lock);
> > > >
> > > >  	return r;
> > > >  }
> > > > @@ -716,6 +718,7 @@ static void imgu_pci_remove(struct pci_dev
> > > *pci_dev)
> > > >  	ipu3_dmamap_exit(imgu);
> > > >  	ipu3_mmu_exit(imgu->mmu);
> > > >  	mutex_destroy(&imgu->lock);
> > > > +	mutex_destroy(&imgu->streaming_lock);
> > > >  }
> > > >
> > > >  static int __maybe_unused imgu_suspend(struct device *dev) diff
> > > > --git a/drivers/staging/media/ipu3/ipu3.h
> > > > b/drivers/staging/media/ipu3/ipu3.h
> > > > index 04fc99f47ebb..f732315f0701 100644
> > > > --- a/drivers/staging/media/ipu3/ipu3.h
> > > > +++ b/drivers/staging/media/ipu3/ipu3.h
> > > > @@ -146,6 +146,10 @@ struct imgu_device {
> > > >  	 * vid_buf.list and css->queue
> > > >  	 */
> > > >  	struct mutex lock;
> > > > +
> > > > +	/* Lock to protect writes to streaming flag in this struct */
> > > > +	struct mutex streaming_lock;
> > > > +
> > > >  	/* Forbit streaming and buffer queuing during system suspend. */
> > > >  	atomic_t qbuf_barrier;
> > > >  	/* Indicate if system suspend take place while imgu is
> > > > streaming. */
> > >
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

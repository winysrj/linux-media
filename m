Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB0DC43612
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EE6B2087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546871550;
	bh=D22wPfOfwlKjaaNYjpDl1y+2sBW1bjd/FjI6LADvXe8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=CWSRZZBq3Pt4zg9xMmRGLIWfkz0YpDEc1St8IGA6/Se7qoy9lvetVhelVqwqYEpwF
	 nMCURwEgp6g41oxps3hsUaZTJth5bjxI8i309n1Ra0LfYzVu5CI+m7INnH16YWPB00
	 d1HUGQg9luryKI3h/Z1NMithepCMml0gBLpltdg4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfAGOc3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:32:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:56174 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfAGOc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=42F1Ky4TEOpUsUExuv+TlXWNU8EtEGQolArg9hANlHk=; b=lc8Psjstw1VOF0gn9zoqowmvnd
        VImRXyhtAZjMZzEntJerfUrxE04u7J14EWqNBqP/QdLtVBl9SB82rQXcZLwauOeCnk9p7kf2FhFyO
        8vqODBcu3vGBQns3xyrs+RuQoZAdTdmfDJ2p60lvAtBctYjuUawvFbFR/wPg3jwRKOcOfI8CFsg1U
        llbV5FdPpbSWVDzQvh1RTyWarreQczmiuRQXAGzy+3XswGwWbLw25Fmah8+JuYAEwxIH2Foc7kuzF
        dOQN4Mu93dfTCpnHHYdXS+4TQ9hU2MxpHCHC0A0cWoE032lRE+mYRweCmGkOmzfPhipYHCUABdnQM
        Nn5s1Nlg==;
Received: from [179.182.170.254] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggVx4-0005MI-Pq; Mon, 07 Jan 2019 14:32:27 +0000
Date:   Mon, 7 Jan 2019 12:32:22 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Dan Ziemba <zman0900@gmail.com>
Cc:     Malcolm Priestley <tvboxspy@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
Subject: Re: [PATCH v3] [bug/urgent] dvb-usb-v2: Fix incorrect use of
 transfer_flags URB_FREE_BUFFER
Message-ID: <20190107123222.50760c8a@coco.lan>
In-Reply-To: <204ed67fafd1ecdc58158da9758a3b6b01ec5ada.camel@gmail.com>
References: <7dd3e986-d838-1210-922c-4f8793eea2e9@gmail.com>
        <204ed67fafd1ecdc58158da9758a3b6b01ec5ada.camel@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sat, 05 Jan 2019 20:49:00 -0500
Dan Ziemba <zman0900@gmail.com> escreveu:

> On Mon, 2018-11-26 at 20:18 +0000, Malcolm Priestley wrote:
> > In commit 1a0c10ed7b media: dvb-usb-v2: stop using coherent memory
> > for URBs
> > incorrectly adds URB_FREE_BUFFER after every urb transfer.
> > 
> > It cannot use this flag because it reconfigures the URBs accordingly
> > to suit connected devices. In doing a call to usb_free_urb is made
> > and
> > invertedly frees the buffers.
> > 
> > The stream buffer should remain constant while driver is up.
> > 
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> > CC: stable@vger.kernel.org # v4.18+

The patch is already there at Kernel 5.0-rc1. Greg merged it today on
his stable trees in order to be merged on Kernels 4.19 and 4.20.

> > ---
> > v3 change commit message to the actual cause
> > 
> >  drivers/media/usb/dvb-usb-v2/usb_urb.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> > b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> > index 024c751eb165..2ad2ddeaff51 100644
> > --- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> > +++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> > @@ -155,7 +155,6 @@ static int usb_urb_alloc_bulk_urbs(struct
> > usb_data_stream *stream)
> >  				stream->props.u.bulk.buffersize,
> >  				usb_urb_complete, stream);
> >  
> > -		stream->urb_list[i]->transfer_flags = URB_FREE_BUFFER;
> >  		stream->urbs_initialized++;
> >  	}
> >  	return 0;
> > @@ -186,7 +185,7 @@ static int usb_urb_alloc_isoc_urbs(struct
> > usb_data_stream *stream)
> >  		urb->complete = usb_urb_complete;
> >  		urb->pipe = usb_rcvisocpipe(stream->udev,
> >  				stream->props.endpoint);
> > -		urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
> > +		urb->transfer_flags = URB_ISO_ASAP;
> >  		urb->interval = stream->props.u.isoc.interval;
> >  		urb->number_of_packets = stream-
> > >props.u.isoc.framesperurb;
> >  		urb->transfer_buffer_length = stream-
> > >props.u.isoc.framesize *
> > @@ -210,7 +209,7 @@ static int usb_free_stream_buffers(struct
> > usb_data_stream *stream)
> >  	if (stream->state & USB_STATE_URB_BUF) {
> >  		while (stream->buf_num) {
> >  			stream->buf_num--;
> > -			stream->buf_list[stream->buf_num] = NULL;
> > +			kfree(stream->buf_list[stream->buf_num]);
> >  		}
> >  	}
> >  
> 
> I have tested this against Arch Linux's kernel packages for both linux
> 4.20 and linux-lts 4.19.13.  For both, the patch seems to fix the
> crashes I reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=201055
> 
> Thanks,
> Dan Ziemba
> 
> 



Thanks,
Mauro

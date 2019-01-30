Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF94C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8592E20882
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 09:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfA3JWf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:22:35 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45441 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfA3JWf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 04:22:35 -0500
Received: from litschi.hi.pengutronix.de ([2001:67c:670:100:feaa:14ff:fe6a:8db5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <m.tretter@pengutronix.de>)
        id 1gom4n-0001Ws-96; Wed, 30 Jan 2019 10:22:33 +0100
Date:   Wed, 30 Jan 2019 10:22:32 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        robh+dt@kernel.org, mchehab@kernel.org, tfiga@chromium.org
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core
 driver
Message-ID: <20190130102232.1047239c@litschi.hi.pengutronix.de>
In-Reply-To: <f0df52b3ac7dfd5bdac8f18053f7db27de5bc230.camel@ndufresne.ca>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
        <20190118133716.29288-3-m.tretter@pengutronix.de>
        <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
        <20190123151709.395eec98@litschi.hi.pengutronix.de>
        <f0df52b3ac7dfd5bdac8f18053f7db27de5bc230.camel@ndufresne.ca>
Organization: Pengutronix
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 2001:67c:670:100:feaa:14ff:fe6a:8db5
X-SA-Exim-Mail-From: m.tretter@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 29 Jan 2019 22:46:15 -0500, Nicolas Dufresne wrote:
> Le mercredi 23 janvier 2019 à 15:17 +0100, Michael Tretter a écrit :
> > > I have a patch pending that allows an encoder to spread the compressed
> > > output over multiple buffers:
> > > 
> > > https://patchwork.linuxtv.org/patch/53536/
> > > 
> > > I wonder if this encoder would be able to use it.  
> > 
> > I don't think that the encoder could use this, because of how the
> > PUT_STREAM_BUFFER and the ENCODE_FRAME command are working: The
> > ENCODE_FRAME will always write the compressed output to a single buffer.
> > 
> > However, if I stop passing the vb2 buffers to the encoder, use an
> > internal buffer pool for the encoder stream buffers and copy the
> > compressed buffer from the internal buffers to the vb2 buffers, I can
> > spread the output over multiple buffers. That would also allow me, to
> > get rid of putting filler nal units in front of the compressed data.
> > 
> > I will try to implement it that way.  
> 
> As explained in my previous email, this will break current userspace
> expectation, and will force userspace into parsing the following frame
> to find the end of it (adding 1 frame latency).
> 
> I have used a lot the vendor driver for this platform and it has always
> been able possible to get the frame size right, so this should be
> possible here too.

The vendor driver estimates the compressed buffer size based on the
width, height, chroma mode and bit depth of the stream. The v4l2
currently uses the dimensions for the estimate and adds some margin
for the SPS/PPS nals and for the partition table. The driver does not
care about the chroma mode and bit depth, yet.

A partition table at the end of the buffer contains the start and size
of the encoded frame in the encoded buffer after it has been encoded.
The vendor driver uses this information later to copy the actual data
out of the buffers. Instead of copying, I copy a filler nal into the
capture buffer and that's something I would be able to avoid by using
internal buffers instead of passing the capture buffers to the VCU.

If the buffer size is not sufficient, the VCU will signal an error and
the driver should be able to trigger a re-negotiation or do the
necessary things to get a larger buffer. However, I didn't test or
implement any of this and this should come later.

So, yes, getting the frame size right should be possible and that's
what the driver in the current state tries to do.

Michael

> 
> Nicolas
> 
> 

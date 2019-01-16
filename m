Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD6BC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 22:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E7220675
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 22:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547676893;
	bh=e0PM2YdWCrq64/TxoG7egLiTQIHzfW4pT9bJWVEiGfE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=LdnvzRPpaKDxNvMmDE/T1gqKnqWJQHTUWsvpjM+yk52bt9Wv4UirGUmosrjsCAkK+
	 eGp6B0/b7rp6TZHCQ1k+zBqE291NrIFJFMisZsIuQgon6px3yiWz7uL4b1eK1AibiK
	 VEGbM73SLXvtdS+6ajPAR6Ho7IyJ6u2V9DPigHxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbfAPWOx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 17:14:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:57776 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732540AbfAPWOx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 17:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=liuD9mk4O3Gtf0mwy5GbN6CUnsx6VnCwcm5L7UWlQco=; b=fZhSuagQyUezoGNj/oY0w5grWN
        FCZd1cThre4i0ai8Zv0YHSyYAgqFJmg1O8dgyaYP3G6jzxo1Oh6PwYCSR0PwnCnOWpkgSpC5xfnRk
        cNNu+1QvJzqXU8XMS5U/aSSQB09q7ySnhRfDirN62wd2FZ/LK+SLcEzfokzCbvu21K+z9HWhYnm/z
        Tz6DhDFuKWzz8UgtHey59AOSpK02KodiD3V7xnn7ELVBAOPxa7kGBkMeDVrIw33goZvfShV40FwUA
        Z1CkQS08bgt9kyanCB75IAYA6tOiarKzKjrG0vhoioqmVUpahdHj35vMDflZRqGJabNkhqpp6EUAs
        ohoXIQmg==;
Received: from [186.213.247.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjtSV-0001VQ-Kl; Wed, 16 Jan 2019 22:14:51 +0000
Date:   Wed, 16 Jan 2019 20:14:48 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH zbar 1/1] Add simple dbus IPC API to zbarcam.
Message-ID: <20190116201448.295b66cd@coco.lan>
In-Reply-To: <CADvTj4oL+h=bgk1yusG0LqEC2itDQ-bThKqEFsztuG6BEqEw-Q@mail.gmail.com>
References: <1547628895-15129-1-git-send-email-james.hilliard1@gmail.com>
        <20190116123659.3908edd4@coco.lan>
        <CADvTj4oL+h=bgk1yusG0LqEC2itDQ-bThKqEFsztuG6BEqEw-Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 16 Jan 2019 13:37:58 -0700
James Hilliard <james.hilliard1@gmail.com> escreveu:

> On Wed, Jan 16, 2019 at 7:37 AM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Hi James,
> >
> > Em Wed, 16 Jan 2019 16:54:55 +0800
> > james.hilliard1@gmail.com escreveu:
> >  
> > > From: James Hilliard <james.hilliard1@gmail.com>
> > >
> > > This is useful for running zbarcam as a systemd service so that other
> > > applications can receive scan messages through dbus.  
> >
> > Nice approach!
> >
> > Yet, I would try to write it on a different way, making sure that it
> > could also be using by zbarimg.
> >
> > I mean, if you add the dbus bindings inside the zbar core, it
> > shouldn't matter if the source image comes via a webcam or via a
> > scanned image. Both will be able to send the scancodes via dbus.  
> Which function should I call send_dbus() from in that case?

Good question.

Tests required, but I suspect that you could add it at processor.c,
inside _zbar_process_image().

I suspect that, if you do something like:

	if(nsyms) {
            /* FIXME only call after filtering */
            _zbar_mutex_lock(&proc->mutex);
            _zbar_processor_notify(proc, EVENT_OUTPUT);
            _zbar_mutex_unlock(&proc->mutex);
            if(proc->handler)
                proc->handler(img, proc->userdata);
+	    if(proc->is_dbus_enabled)
+		zbar_send_code_via_dbus(proc->userdata);
        }

should work.

You could easily check if this is working by calling:

	$ ./zbarimg/zbarimg ./examples/barcode.png
	EAN-13:9876543210128
	scanned 1 barcode symbols from 1 images in 0.2 seconds


(I would add a flag to allow enabling/disabling it by applications).


> >
> > As a future approach, we may even think on making the interface
> > duplex in the future, e. g. allowing any camera application to
> > send an image via dbus and let zbar to decode it and return
> > the decoded bar codes.  
> That could be useful, probably too difficult for me to implement
> myself though(I don't write a lot of c usually).

As I said, this is just an idea for a future possible development.

Not sure how this would actually work, as dbus may not be the best
interface for passing images.


Thanks,
Mauro

Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405A4C07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 11:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E68F520831
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 11:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544354876;
	bh=RqjeOVfFB97wuWBfSBSZaVbXVb6ONw692OS9qoAZboQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=0f7Ev87KUa2YRyQO43jbQ+aDwy8rAwWl+88MQsjT+guqLV5r2vJuvv1daonYayBy2
	 XH5xkJhPvBh4aC2Whq0IfJIw4ZpebxHVNIClR0+CP77dZpCHnEv2hlPlkRsjPn/vL/
	 nZVD9MZGQkihgWi5YJsdhsZ4vuVjUJypAUsNeiW8=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E68F520831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeLIL1v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 06:27:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:56566 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbeLIL1v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 06:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vQKcvzs2j28Xr+xvAUQTaGc5maZ63ktSNzVQ6E3MUf0=; b=FXwNtHIYSLseCKRrtNQ7rgyuZ/
        CAt/UZH8HzIBqZz5szfmHeoys5IpW7lCYMrebOxmYn2CkIkNW8Xy6dRhPpDtgTNnWxCn8UoZ+8Mxs
        v6Po/JrVZlnA5N7UaSgekxBTbjXEw/n4uRvHtWNYK5AiGJzOpPyJKEhdDZNhpmwiuELepIbhqS+Fv
        9EPAKfFHpLK/eAyU2/euVeVpen09/LZGdDl6AMoH+ylqVTPJggqBgajjqOF6uH7rkVfY3nHOc82u1
        Rfx0FwJ4iLILK+4zNPZVLOztUsmP5cRd4nqJJ0tEsb+QBjFhefOl4ojd3oI2Qc2LiaMWWgq0HVrSz
        SuqMJItw==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVxFN-0002UG-F2; Sun, 09 Dec 2018 11:27:41 +0000
Date:   Sun, 9 Dec 2018 09:27:36 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     shuah <shuah@kernel.org>, perex@perex.cz, tiwai@suse.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC PATCH v8 1/4] media: Media Device Allocator API
Message-ID: <20181209092715.50a7e4e4@coco.lan>
In-Reply-To: <20181209080944.GA7561@amd>
References: <cover.1541109584.git.shuah@kernel.org>
        <e474dd16f1d6443c12b1361376193c9d0efcced6.1541109584.git.shuah@kernel.org>
        <20181119085931.GA28607@amd>
        <73c22137-9c7a-75c8-8cd1-3736c63c2d40@kernel.org>
        <20181209080944.GA7561@amd>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sun, 9 Dec 2018 09:09:44 +0100
Pavel Machek <pavel@ucw.cz> escreveu:

> On Thu 2018-12-06 08:33:14, shuah wrote:
> > On 11/19/18 1:59 AM, Pavel Machek wrote:  
> > >On Thu 2018-11-01 18:31:30, shuah@kernel.org wrote:  
> > >>From: Shuah Khan <shuah@kernel.org>
> > >>
> > >>Media Device Allocator API to allows multiple drivers share a media device.
> > >>Using this API, drivers can allocate a media device with the shared struct
> > >>device as the key. Once the media device is allocated by a driver, other
> > >>drivers can get a reference to it. The media device is released when all
> > >>the references are released.  
> > >
> > >Sounds like a ... bad idea?
> > >
> > >That's what new "media control" framework is for, no?
> > >
> > >Why do you need this?  
> > 
> > Media control framework doesn't address this problem of ownership of the
> > media device when non-media drivers have to own the pipeline. In this case,
> > snd-usb owns the audio pipeline when an audio application is using the
> > device. Without this work, media drivers won't be able to tell if snd-usb is
> > using the tuner and owns the media pipeline.
> > 
> > I am going to clarify this in the commit log.  
> 
> I guess I'll need the explanation, yes.
> 
> How can usb soundcard use the tuner? I thought we'd always have
> userspace component active and moving data between tuner and usb sound
> card?

It sounds that the description of the patch is not 100%, as it seems
that you're not seeing the hole picture.

This is designed to solve a very common usecase for media devices
where one physical device (an USB stick) provides both audio
and video.

That's, for example, the case of cameras with microphones and 
TV USB devices. Those usually expose the audio via standard
USB Audio Class, and video either via USB Video Class or via
some proprietary vendor class.

Due to the way USB Audio Class is handled, it means that two
independent drivers will provide the pipelines for a single
physical USB bridge.

The same problem also applies to more sophisticated embedded devices,
like on  SOCs designed to be used on TVs and Set Top Boxes, where the
hardware pipeline has both audio and video components on it, logically
mapped into different drivers (using Linux DTV API, V4L2 API and ALSA).

On such kind of devices, it is important to have a way to see
and control the entire audio and video pipeline present on them 
through a single media controller device, specially if one wants
to provide a hardware pipeline within the SoC that won't be 
copying data between Kernel-userspace.

Now, if the audio is implemented on a separate device (like an
Intel HDA compatible chipset at the motherboard), it should
be exposed as a separate media controller.

So, for example, a system that has both an USB audio/video
stick and an Intel HDA-compatible chipset, both exposed via
the media controller, will have two media controller devices,
one for each physically independent device.

On the other hand, an SoC designed for TV products will likely
expose a single media controller, even if each part of the
pipeline is exposed via independent Linux device drivers.

Thanks,
Mauro

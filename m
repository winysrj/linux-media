Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C06C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0903121019
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 11:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="immvSBZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfAVLIQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:08:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51338 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfAVLIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 06:08:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so13706844wmj.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 03:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hBoQT6Mq3xgihjRvJjdy/2+Cj6i8r5rb821zKmeN3Eo=;
        b=immvSBZ0ev8zye7JrkRtHdS3bACAncAayZnM4sZUPfRKyIgoEiwFUlPNpb+DmoxqKH
         oz/QTxjcPosEk7UnMLB7VFWqhG4iUQYk6FWe51xNq4LyMv4M+PHz7kOZght0uhOTzapD
         ys7oOyZW/Zx2TVVs8pH/q9ewFrAPWylPo6Gw+Mx1cLqUS8Y9gOzwOB3SwjLlVvU5RyK3
         Mng40mFmycB9asfqEm55ZHM1STqFSNvQm/f1BN/CvrQiIE8W5O5DGsIsKHh/CDuCDTQA
         Ia0J5NVedpbfumW0eSTdd7V1vwNdgj0LxVPBuAk8bOxbyBFVfoa7ajb6aw00C3qvI6ON
         vw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hBoQT6Mq3xgihjRvJjdy/2+Cj6i8r5rb821zKmeN3Eo=;
        b=odkuOwNbmc9qFXg5vxDxhDdIsJ0riJSGVFVe8NFPrBtuEbgYextCbsEdvCuwmEcOK6
         RbM5hI1I7KfPH15CzG1PZyOHUQxmfzLbz/zQ8i25G2W6AhqDQWRjLKDAdnp9kD1l79j5
         DlZXXkSwUkiYDLwhFTqDuumFJngO1KbOGQXFYx5onAH+eE7v2qWzFwWwpVP9XZnRgB78
         fpfiDyBYhhZgGXqkS1taQj7SCHJHFq3BbEoGnJLBN0ljk53fjCZUV9wybfsl8yz/cg6H
         2sJWnKn1aqoqdyMhF4k9l0PIPzdXNO3t9zmfj8tsh3JZxCVmvUxPg5RLevHcfRi79z2Y
         kIHg==
X-Gm-Message-State: AJcUukfccj90u9UH8oTFNBzlNUSDbEq0DC9x739z86lbe46wLEJW6Khr
        +nPAaLOZL5QGtl2RxjB83gw=
X-Google-Smtp-Source: ALg8bN7GF9KkzbBTqXLmpOrE6fh4FVFM9g0vD1uo8npv91G8Viqdy/xamudQ1o0wNxwLfaLmoGiE1g==
X-Received: by 2002:a1c:e913:: with SMTP id q19mr3303163wmc.55.1548155292915;
        Tue, 22 Jan 2019 03:08:12 -0800 (PST)
Received: from vero4k (cpc152529-shef18-2-0-cust394.17-1.cable.virginm.net. [77.100.29.139])
        by smtp.gmail.com with ESMTPSA id y13sm59265787wme.2.2019.01.22.03.08.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 03:08:12 -0800 (PST)
Date:   Tue, 22 Jan 2019 11:08:10 +0000
From:   James Hutchinson <jahutchinson99@googlemail.com>
To:     Antti Palosaari <crope@iki.fi>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH] media: m88ds3103: serialize reset messages in
 m88ds3103_set_frontend
Message-ID: <20190122110810.l2zmvyepwswfv3bl@vero4k>
References: <1547414027-31928-1-git-send-email-jahutchinson99@googlemail.com>
 <7b9b8291-4768-80bd-b3b1-c6556801d060@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9b8291-4768-80bd-b3b1-c6556801d060@iki.fi>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Jan 20, 2019 at 04:43:08PM +0200, Antti Palosaari wrote:
> On 1/13/19 11:13 PM, James Hutchinson wrote:
> > Ref: https://bugzilla.kernel.org/show_bug.cgi?id=199323
> > 
> > Users are experiencing problems with the DVBSky S960/S960C USB devices
> > since the following commit:
> > 
> > 9d659ae: ("locking/mutex: Add lock handoff to avoid starvation")
> > 
> > The device malfunctions after running for an indeterminable period of
> > time, and the problem can only be cleared by rebooting the machine.
> > 
> > It is possible to encourage the problem to surface by blocking the
> > signal to the LNB.
> > 
> > Further debugging revealed the cause of the problem.
> > 
> > In the following capture:
> > - thread #1325 is running m88ds3103_set_frontend
> > - thread #42 is running ts2020_stat_work
> > 
> > a> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 80
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 08
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 68 3f
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 08 ff
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 3d
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
> > b> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 00
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 21
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> >     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 66
> >     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 60 02 10 0b
> >     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> > 
> > Two i2c messages are sent to perform a reset in m88ds3103_set_frontend:
> > 
> >    a. 0x07, 0x80
> >    b. 0x07, 0x00
> > 
> > However, as shown in the capture, the regmap mutex is being handed over
> > to another thread (ts2020_stat_work) in between these two messages.
> > 
> > > From here, the device responds to every i2c message with an 07 message,
> > and will only return to normal operation following a power cycle.
> > 
> > Use regmap_multi_reg_write to group the two reset messages, ensuring
> > both are processed before the regmap mutex is unlocked.
> 
> I tried to reproduce that issue with pctv 461e, which has em28xx
> usb-interface, but without success. Even when I added some sleep between
> reset commands and increased tuner statistic polling interval such that it
> polls all the time, it works correctly. Device has tuner is connected to
> demod i2c bus, which I think is same for your device (it calls demod i2c mux
> select for every tuner i2c access).
> 
> Taking into account tests I made it is probably issue with usb-interface i2c
> adapter instead - for some reason it stops working and starts returning 07
> error all the time. Did any other I2C command succeed after failure? I mean
> is there any other i2c client on that bus you could test if it fails too on
> error situation?
> 
> All in all, fix should be done to usb-interface i2c adapter if possible
> unless it has proven issue is somewhere else. You could try to add some
> sleep or repeat to i2c adapter in order to see if it helps.
> 
> regards
> Antti
> 
> -- 
> http://palosaari.fi/

Thanks for taking the time to review my patch.

My device is the dvbsky usb s960 which is a pretty popular device and hasn't
been working for several users since commit 9d659ae.

I did some further investigation and can now see that the issue likely only
affects adapters which use the m88ds3103_get_agc_pwm function to get the AGC
from the demodulator as part of ts2020_stat_work.

This is the 3f message in my original capture, which gets an ff response.
    [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 68 3f
    [42] usb 1-1: dvb_usb_v2_generic_io: <<< 08 ff

The m88ds3103_get_agc_pwm function looks to be used by a subset of devices and
their variants from the dvbsky usb-interface (s960 & s960c), and the cx23885-dvb
pci-interface (s950, s950c, s952).

The problem does NOT occur if I disable auto-gain correction by removing the
following line from dvbsky_s960_attach:

    ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;

I then have the same experience as you; I can add a sleep between the reset
commands and increase the tuner statistic polling interval, and it still
works correctly.

I can also reproduce the issue on older kernels (pre-commit 9d659ae) by adding
a sleep between the two reset commands and leaving the agc read enabled.

Whilst my original patch works around the issue, I'm not sure it's really
addressing the root cause, and I do wonder whether other areas of the m88ds3103
module may end up needing to be protected in a similar way.

Afterall, the ts2020 stat work thread runs every 2000ms, and there's currently
no guarantee what state the demodulator is going to be in at that time.

Regards,
James.


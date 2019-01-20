Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5693FC636A2
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 14:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E42CE2087B
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 14:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="XHx2ocPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfATOnM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 09:43:12 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:58449 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfATOnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 09:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y7sjrcidFqJ7o9HMij1R6FCIGDicPtuJGgbUAu9r2Kw=; b=XHx2ocPhftYc+Z+biFzlSG/qyH
        ba76OosIr0BjLh4w2jXVHJG1zplSgVJXYjxeXhk96dTqSwr/N/ziGRzhx1t0Pu+LCXXTQo/vehFkt
        hs/3dpufp5TYexqD2XmD7FP8FhfwOzIbfDGvP2yecfaFnh6lTKEOn9d46dB4/pe8fh42xBLNujpWs
        5bseKUC5vvFHhP+uTDWgAB+4JsUwsb//XZtM8/x0XhrVlS7ZTiQwMYLb7/Z4Ac2JBZGS+7kR2jhSi
        GDfTxVM/W7QiaARmActU5luMem3zSJGhpeobYuXR38SL0hJuuH+sHKdyunYjgei/d+9f63vrrW9zl
        UnvLZI4A==;
Received: from 87-92-92-105.bb.dnainternet.fi ([87.92.92.105] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <crope@iki.fi>)
        id 1glEJY-0003Zf-CQ; Sun, 20 Jan 2019 16:43:08 +0200
Subject: Re: [PATCH] media: m88ds3103: serialize reset messages in
 m88ds3103_set_frontend
To:     James Hutchinson <jahutchinson99@googlemail.com>,
        linux-media@vger.kernel.org
References: <1547414027-31928-1-git-send-email-jahutchinson99@googlemail.com>
From:   Antti Palosaari <crope@iki.fi>
Message-ID: <7b9b8291-4768-80bd-b3b1-c6556801d060@iki.fi>
Date:   Sun, 20 Jan 2019 16:43:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1547414027-31928-1-git-send-email-jahutchinson99@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 87.92.92.105
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/13/19 11:13 PM, James Hutchinson wrote:
> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=199323
> 
> Users are experiencing problems with the DVBSky S960/S960C USB devices
> since the following commit:
> 
> 9d659ae: ("locking/mutex: Add lock handoff to avoid starvation")
> 
> The device malfunctions after running for an indeterminable period of
> time, and the problem can only be cleared by rebooting the machine.
> 
> It is possible to encourage the problem to surface by blocking the
> signal to the LNB.
> 
> Further debugging revealed the cause of the problem.
> 
> In the following capture:
> - thread #1325 is running m88ds3103_set_frontend
> - thread #42 is running ts2020_stat_work
> 
> a> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 80
>     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 08
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 68 3f
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 08 ff
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 3d
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
> b> [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 07 00
>     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 21
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07
>     [42] usb 1-1: dvb_usb_v2_generic_io: >>> 09 01 01 60 66
>     [42] usb 1-1: dvb_usb_v2_generic_io: <<< 07 ff
>     [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 68 02 03 11
>     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
>     [1325] usb 1-1: dvb_usb_v2_generic_io: >>> 08 60 02 10 0b
>     [1325] usb 1-1: dvb_usb_v2_generic_io: <<< 07
> 
> Two i2c messages are sent to perform a reset in m88ds3103_set_frontend:
> 
>    a. 0x07, 0x80
>    b. 0x07, 0x00
> 
> However, as shown in the capture, the regmap mutex is being handed over
> to another thread (ts2020_stat_work) in between these two messages.
> 
>>From here, the device responds to every i2c message with an 07 message,
> and will only return to normal operation following a power cycle.
> 
> Use regmap_multi_reg_write to group the two reset messages, ensuring
> both are processed before the regmap mutex is unlocked.

I tried to reproduce that issue with pctv 461e, which has em28xx 
usb-interface, but without success. Even when I added some sleep between 
reset commands and increased tuner statistic polling interval such that 
it polls all the time, it works correctly. Device has tuner is connected 
to demod i2c bus, which I think is same for your device (it calls demod 
i2c mux select for every tuner i2c access).

Taking into account tests I made it is probably issue with usb-interface 
i2c adapter instead - for some reason it stops working and starts 
returning 07 error all the time. Did any other I2C command succeed after 
failure? I mean is there any other i2c client on that bus you could test 
if it fails too on error situation?

All in all, fix should be done to usb-interface i2c adapter if possible 
unless it has proven issue is somewhere else. You could try to add some 
sleep or repeat to i2c adapter in order to see if it helps.

regards
Antti

-- 
http://palosaari.fi/

Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3FAC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 20:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F9920660
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 20:42:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsuQvNu4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfAHUmG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 15:42:06 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33985 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728723AbfAHUmF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 15:42:05 -0500
Received: by mail-lf1-f46.google.com with SMTP id p6so3990647lfc.1
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 12:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=EmsnYTCIq2LJooWhzEUoTy26QvTgqeuy+mvDgRjmJ7Y=;
        b=GsuQvNu4kHztxbWkJP05GoXnyKQ6QZ/FuuK5a4FD0LhOiOGcc9ujcgaoYM6jsRc7bM
         RSks/RoBjb0GoZqmkhPQSU98F7QvYfw+mvVK5hgb0W0eACdJoyXaDWxvLRu2sx/cxZ6D
         t/b3yAtRaywFCJvX/Bd/Zfx68X7Y42yq+hEmY7PH2iNP2QMmWYsdxdOCRS394aBvYD8/
         BXs3eB8njyH+NvULXuQ8zKUXfDyUzwHmPLC+vChocY8n4q8yZwTrxPFWSwePl1fBUiy+
         tr/90cf6rNQxI/2BezCekEjjtmyOJ5TsgQDHPjHQdb8tmx1d49nGhweECeSwp+5HTBKb
         cp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EmsnYTCIq2LJooWhzEUoTy26QvTgqeuy+mvDgRjmJ7Y=;
        b=oUMWtIOh9+nZaE9xX00kviDMnOuPTnOGjQc3BuBECJOYBN4eQj4hoDmg/q9NttG4pq
         XP8eBHtPoQQOwlL5mONDQvauBiW7iLc9pPUPyRESNooU6so2h6DdfmnHMG9v4SHCgxZE
         N/KDxKpwOiWr30HUrTyd/PLvGFn+ApTId7Tozl2DH0sUSMM3fQc4hW1bPmhrjD2+5/Xr
         xpw7UXxhVFjmpTY1tM/QdJS+UxxqjB8hbhpqB1t8lwWqohE4hwAhXCYuoKAhe21XXhuR
         N4MKQTy2oW9BdvvEroqSDBiel4YDUZJCenRBW8V/3pTZpK/YegfzYEcY45PXH6hgbrPi
         WHvg==
X-Gm-Message-State: AJcUukdWhCdCiYYLz8dKWx8t/l3uFRdV8/Tp7q/1Yook5DKi66eOcGG0
        n8Ho/+kyQNiw5eFPWosI6LCg21P5oNF9Hpxg4eHoQQfo
X-Google-Smtp-Source: ALg8bN6Rmml7Yf4Uij6psrANbE0rIYlYmzrvriinagvDCduGLTXYXGmvgvutoXdl4vTQTj417uAfq+TirDyouQMmBe8=
X-Received: by 2002:a19:4849:: with SMTP id v70mr1852526lfa.62.1546980122311;
 Tue, 08 Jan 2019 12:42:02 -0800 (PST)
MIME-Version: 1.0
From:   CIJOML CIJOMLovic <cijoml@gmail.com>
Date:   Tue, 8 Jan 2019 21:41:50 +0100
Message-ID: <CAB0z4NqDaf37GHyRX3sVVzLrBJGJpkgEG0FNd1ahX-Ww4AkOYg@mail.gmail.com>
Subject: Astrometa swap frontend0 and frontend1
To:     linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

I have an Astrometa DVB-T2 dual USB card:

[41802.362830] usb 3-3: new high-speed USB device number 4 using xhci_hcd
[41802.520747] usb 3-3: New USB device found, idVendor=15f4,
idProduct=0131, bcdDevice= 1.00
[41802.520751] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[41802.520753] usb 3-3: Product: dvbt2
[41802.520755] usb 3-3: Manufacturer: astrometadvbt2
[41802.527992] usb 3-3: dvb_usb_v2: found a 'Astrometa DVB-T2' in warm state
[41802.597901] usb 3-3: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[41802.597907] dvbdev: DVB: registering new adapter (Astrometa DVB-T2)
[41802.625041] i2c i2c-10: Added multiplexed i2c bus 11
[41802.625045] rtl2832 10-0010: Realtek RTL2832 successfully attached
[41802.631564] mn88473 10-0018: Panasonic MN88473 successfully identified
[41802.631612] usb 3-3: DVB: registering adapter 0 frontend 0 (Realtek
RTL2832 (DVB-T))...
[41802.631755] usb 3-3: DVB: registering adapter 0 frontend 1
(Panasonic MN88473)...
[41802.631947] r820t 11-003a: creating new instance
[41802.638797] r820t 11-003a: Rafael Micro r820t successfully identified
[41802.638863] r820t 11-003a: attaching existing instance
[41802.643622] r820t 11-003a: Rafael Micro r820t successfully identified
[41802.646497] rtl2832_sdr rtl2832_sdr.1.auto: Registered as swradio0
[41802.646499] rtl2832_sdr rtl2832_sdr.1.auto: Realtek RTL2832 SDR attached
[41802.646501] rtl2832_sdr rtl2832_sdr.1.auto: SDR API is still
slightly experimental and functionality changes may follow
[41802.653040] Registered IR keymap rc-empty
[41802.653107] rc rc0: Astrometa DVB-T2 as
/devices/pci0000:00/0000:00:14.0/usb3/3-3/rc/rc0
[41802.653250] input: Astrometa DVB-T2 as
/devices/pci0000:00/0000:00:14.0/usb3/3-3/rc/rc0/input29
[41802.653762] rc rc0: lirc_dev: driver dvb_usb_rtl28xxu registered at
minor = 0, raw IR receiver, no transmitter
[41802.653858] usb 3-3: dvb_usb_v2: schedule remote query interval to 200 msecs
[41802.665572] usb 3-3: dvb_usb_v2: 'Astrometa DVB-T2' successfully
initialized and connected

I would like swap frontend0 and frontend1 with UDEV. Would anybody
help me? The frontend0 is DVB-T tuner, but this terrestrial norm is to
be switch off. So I would like use DVB-T2 tuner which is currently
frontend1. I have to use manual intervention since I was not able to
teach udev to do it for me (kaffeine works only with frontend0)

Any clue please?

Thank you

Michal

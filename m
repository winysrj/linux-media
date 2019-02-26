Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88854C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F12F20851
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfBZWXv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:23:51 -0500
Received: from er-systems.de ([148.251.68.21]:33508 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbfBZWXv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 17:23:51 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id C3307D6006E;
        Tue, 26 Feb 2019 23:23:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id 9D72BD6006D;
        Tue, 26 Feb 2019 23:23:46 +0100 (CET)
Date:   Tue, 26 Feb 2019 23:23:45 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: DVB-C no EPG data with kernel v5.0-rc
In-Reply-To: <alpine.LSU.2.21.1902261903290.30554@er-systems.de>
Message-ID: <alpine.LSU.2.21.1902262317110.8659@er-systems.de>
References: <alpine.LSU.2.21.1902261903290.30554@er-systems.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.100.2/25372/Tue Feb 26 11:34:09 2019 signatures 58.
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 26 Feb 2019, Thomas Voegtle wrote:

> Hello,
>
> I have a
>
> 03:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23887/8 PCIe Broadcast Audio and Video Decoder with 3D Comb [14f1:8880]
> (rev 04)
>         Subsystem: Hauppauge computer works Inc. Device [0070:c138]
>         Kernel driver in use: cx23885
>
> on linux 5.0.0-rc8.
>
> In dmesg I see lines like this:
>
> [   17.925917] tda10071 7-0005: found a 'NXP TDA10071' in cold state, will 
> try to load a firmware
> [   17.925920] tda10071 7-0005: downloading firmware from file 
> 'dvb-fe-tda10071.fw'
> [   22.722865] tda10071 7-0005: firmware version 1.21.31.2
> [   22.722867] tda10071 7-0005: found a 'NXP TDA10071' in warm state
> [   22.762084] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 0...0, frontend: 950000000...2150000000
> [   22.817566] si2165 7-0064: downloading firmware from file 
> 'dvb-demod-si2165.fw' size=5768
> [   22.820633] si2165 7-0064: si2165_upload_firmware: extracted 
> patch_version=0x9a, block_count=0x27, crc_expected=0xcc0a
> [   23.906627] si2165 7-0064: fw load finished
> [   23.911549] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> [   77.351619] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> [   98.609998] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> [  119.615057] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> [  140.620080] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> [  161.645094] dvb_frontend: dvb_frontend_get_frequency_limits: frequency 
> interval: tuner: 45000000...864000000, frontend: 0...0
> ...
>
> The last line is repeated regularly.
> I have noticed that vdr doesn't save something in epg.data, when I deleted 
> the file and reboot, no new data is saved until I boot kernel 4.20 or older.

I got into that a bit more and I have to say that I'm wrong about that EPG 
data. I can't really see a pattern, it feels like receiveing EPG data 
takes much longer with 5.0-rc as older kernel do, but I just can be wrong.

But then... for what is that debug message repeated regularly? Is there 
something wrong or not?

Thanks,

       Thomas


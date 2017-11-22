Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37422 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdKVTvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 14:51:01 -0500
Received: by mail-wm0-f49.google.com with SMTP id v186so12465540wma.2
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 11:51:00 -0800 (PST)
From: Gregor Jasny <gjasny@googlemail.com>
Subject: dvbv5-scan: Missing NID, TID, and RID in VDR channel output
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <f65773a8-603a-ba10-b420-896efc70c26a@googlemail.com>
Date: Wed, 22 Nov 2017 20:50:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro and list,

since some days my region in Germany finally got DVB-T2 coverage.
Something in the broadcasted tabled makes w_scan only find a subset each
time. dvbv5-scan is somewhat more reliable.  But with the VDR compatible
channel list exported from dvbv5-scan I cannot make VDR produce any EPG.
>From skimming over the VDR code I think this is due to missing NID and TID.

The upper one is from dvbv5-scan, the lower one from w_scan:

>                                                                       VPID    APID                   TPID  CA SID  NID   TID    RID
> arte HD    :618000:B8 C999 D999 G19128 I999 M999 S1 T16 Y0   :T:27500 :210    :220,221               :0    :0 :770 :0    :0     :0
> arte HD;ARD:618000:B8      D0   G19256           S1 T32 Y0 P0:T:27500 :210=36 :220=deu@17,221=fra    :230  :0 :770 :8468 :15106 :0

Mauro, do you think it would be possible to parse / output NID, TID, and
RID from dvbv5_scan? It would greatly improve usability. Now that w_scan
is unmaintained, dvb5-scan is the only maintained DVB-T2 scanning app:

https://linuxtv.org/wiki/index.php/Frequency_scan#Comparison_of_DVB_frequency_scanning_commandline_utilities

Thanks,
Gregor

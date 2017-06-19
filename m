Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59413 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752637AbdFSO6l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:58:41 -0400
Received: from webmail.free.fr (unknown [172.20.243.54])
        by smtp1-g21.free.fr (Postfix) with ESMTP id A868CB0055E
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 16:58:40 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Jun 2017 16:58:40 +0200
From: Thierry Lelegard <thierry.lelegard@free.fr>
To: linux-media@vger.kernel.org
Subject: LinuxTV V3 vs. V4 API doc inconsistency, V4 probably wrong
Reply-To: thierry@lelegard.fr
Message-ID: <3188f2a2bcba758dccaaa8cdbbd694fb@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

There is an ambiguity in the LinuxTV documentation about the following 
ioctl's:

    FE_SET_TONE, FE_SET_VOLTAGE, FE_DISEQC_SEND_BURST.

These ioctl's take an enum value as input. In the old V3 API, the 
parameter
is passed by value. In the S2API documentation, it is passed by 
reference.
Most sample programs (a bit old) use the "pass by value" method.

V3 documentation: https://www.linuxtv.org/docs/dvbapi/dvbapi.html
    int ioctl(int fd, int request = FE_SET_TONE, fe_sec_tone_mode_t 
tone);
    int ioctl(int fd, int request = FE_SET_VOLTAGE, fe_sec_voltage_t 
voltage);
    int ioctl(int fd, int request = FE_DISEQC_SEND_BURST, 
fe_sec_mini_cmd_t burst);

S2API documentation: 
https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/frontend_fcalls.html
    int ioctl(int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone)
    int ioctl(int fd, FE_SET_VOLTAGE, enum fe_sec_voltage *voltage)
    int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd *tone)

Also in: 
https://www.kernel.org/doc/html/v4.10/media/uapi/dvb/frontend_fcalls.html

Which one is correct? If both are correct and the API was changed (I 
doubt about it),
how can we know which one to use?

Normally, I would say that the most recent doc is right. However, all 
sample
codes use "by value". Moreover, if the most recent doc was right, then 
passing
by value should fail since the values are zero or close to zero and are 
not
valid addresses.

Thanks
-Thierry

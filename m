Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0082.outbound.protection.outlook.com ([104.47.41.82]:16800
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754329AbdFEQch (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 12:32:37 -0400
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:55688 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <rohit.athavale@xilinx.com>)
        id 1dHuvX-0001rd-P6
        for linux-media@vger.kernel.org; Mon, 05 Jun 2017 09:32:23 -0700
Received: from localhost ([127.0.0.1] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <rohit.athavale@xilinx.com>)
        id 1dHuvX-0000MS-Nb
        for linux-media@vger.kernel.org; Mon, 05 Jun 2017 09:32:23 -0700
Received: from [172.19.131.25] (helo=XSJ-PVEXCAS01.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <RATHAVAL@xilinx.com>)
        id 1dHuvX-0000MP-DV
        for linux-media@vger.kernel.org; Mon, 05 Jun 2017 09:32:23 -0700
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Question about Large Custom Coefficients for V4L2 sub-device drivers
Date: Mon, 5 Jun 2017 16:32:24 +0000
Message-ID: <866603A3C4C8F547969034C425C3995F494A3336@XSJ-PSEXMBX01.xlnx.xilinx.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Media Community,

I am working on a scaler and gamma correction V4L2 sub-device based drivers=
. A common theme to both of them is that
the kernel driver is expected bring-up these devices in a working (good) co=
nfiguration. As it turns out these coefficients are tailor-made
or are fairly complex to generate dynamically at run-time.

This implies the driver has to store at least one set of coefficients for e=
ach supported configuration. This could easily become 10-20 KB of data stor=
ed as a large static array of shorts or integers.

I have a couple of questions to ask all here :

1. What is the best practice for embedding large coefficients ( > 10 KB) in=
to V4L2 sub-device based drivers ?

2. How can user applications feed coefficients to the sub-device based V4L2=
 drivers ? I'm wondering if there is standard ioctl, write or mmap file op =
that can be performed to achieve this ?

All inputs will be greatly appreciated :)

Best Regards,
Rohit



This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0079.outbound.protection.outlook.com ([104.47.38.79]:11728
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752835AbeGGHwF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Jul 2018 03:52:05 -0400
From: Suresh Gupta <sureshg@xilinx.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Multi M2M devices from one driver
Date: Sat, 7 Jul 2018 07:51:58 +0000
Message-ID: <DM6PR02MB4009B09524EBF67DFB6A0FD6DA460@DM6PR02MB4009.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Experts,

We have a multi-functional scalar which has multiple inputs and multiple ou=
tputs.
We want to hook  this with a V4L2 M2M framework, but as per my limited unde=
rstanding M2M framework does not support multiple inputs and multiple outpu=
ts.
So I am thinking to register multiple video4linux devices and initialize pe=
r-devices m2m data in one driver probe & allocate and initialize multiple m=
2m context per open call and actual driver run will call only when all open=
ed devices calls streamon.

Do you think this approach works for us? Do you have any other idea?

Also, is there any why to queue same memory pointer as an output of one m2m=
 queue and input of another queue without using memory copy, required if I =
use V4L2_MEMORY_USERPTR.

Thanks
SuresH
This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.

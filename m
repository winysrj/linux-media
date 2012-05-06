Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37077 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab2EFAmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 20:42:33 -0400
References: <CACOfU4NXM5itsw17bRhtNeDP+-dbCM+Ms84k47NbPf6NjzOmtw@mail.gmail.com>
In-Reply-To: <CACOfU4NXM5itsw17bRhtNeDP+-dbCM+Ms84k47NbPf6NjzOmtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: error - cx18 driver
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 05 May 2012 20:42:39 -0400
To: Hector Catre <hcatre@gmail.com>, linux-media@vger.kernel.org
Message-ID: <5dd58a2c-0789-423d-8bd1-e583edcba17d@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hector Catre <hcatre@gmail.com> wrote:

>Note: I’m a relatively n00b trying to set up mythtv and having issues
>installing the hauppage hvr-1600 tuner/capture card.
>
>When I run dmesg, I get the following:
>
>[  117.013178]  a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca
>- sn9c20x: Change the exposure setting of Omnivision sensors
>[  117.013183]  4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca
>- sn9c20x: Don't do sensor update before the capture is started
>[  117.013188]  c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca
>- sn9c20x: Set the i2c interface speed
>[  117.028665] cx18: Unknown symbol i2c_bit_add_bus (err 0)
>
>Help.
>
>Thanks,
>H
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

You must ensure i2c_algo_bit.ko exists as a kernel module or that i2c_algo_bit is built into your kernel.

Regards,
Andy

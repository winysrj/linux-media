Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38363 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2EFBk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 21:40:59 -0400
Received: by obbtb18 with SMTP id tb18so6194476obb.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 18:40:58 -0700 (PDT)
From: "Hector Catre" <hcatre@gmail.com>
To: "'Andy Walls'" <awalls@md.metrocast.net>,
	<linux-media@vger.kernel.org>
References: <CACOfU4NXM5itsw17bRhtNeDP+-dbCM+Ms84k47NbPf6NjzOmtw@mail.gmail.com> <5dd58a2c-0789-423d-8bd1-e583edcba17d@email.android.com>
In-Reply-To: <5dd58a2c-0789-423d-8bd1-e583edcba17d@email.android.com>
Subject: RE: error - cx18 driver
Date: Sat, 5 May 2012 21:41:10 -0400
Message-ID: <0ace01cd2b29$513a4840$f3aed8c0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-ca
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Andy.
Again I'm a n00b, thus, can you point me to a page or resource where I can find and install i2c_algo_bit?
Thanks again,
H

-----Original Message-----
From: Andy Walls [mailto:awalls@md.metrocast.net] 
Sent: May-05-12 8:43 PM
To: Hector Catre; linux-media@vger.kernel.org
Subject: Re: error - cx18 driver

Hector Catre <hcatre@gmail.com> wrote:

>Note: I’m a relatively n00b trying to set up mythtv and having issues 
>installing the hauppage hvr-1600 tuner/capture card.
>
>When I run dmesg, I get the following:
>
>[  117.013178]  a1ac5dc28d2b4ca78e183229f7c595ffd725241c [media] gspca
>- sn9c20x: Change the exposure setting of Omnivision sensors [  
>117.013183]  4fb8137c43ebc0f5bc0dde6b64faa9dd1b1d7970 [media] gspca
>- sn9c20x: Don't do sensor update before the capture is started [  
>117.013188]  c4407fe86d3856f60ec711e025bbe9a0159354a3 [media] gspca
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
>the body of a message to majordomo@vger.kernel.org More majordomo info 
>at  http://vger.kernel.org/majordomo-info.html

You must ensure i2c_algo_bit.ko exists as a kernel module or that i2c_algo_bit is built into your kernel.

Regards,
Andy


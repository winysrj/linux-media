Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33988 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdBMUxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 15:53:40 -0500
Received: by mail-wr0-f195.google.com with SMTP id c4so161643wrd.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 12:53:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170208133741.GA4405@gofer.mess.org>
References: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
 <20170208133741.GA4405@gofer.mess.org>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Tue, 14 Feb 2017 07:53:37 +1100
Message-ID: <CAEsFdVP4hh1nZh7oPUgaZ0mWvW7e=pZQKv3NA429BfDeKMQd6w@mail.gmail.com>
Subject: Re: [regression] dvb_usb_cxusb (was Re: ir-keytable: infinite loops, segfaults)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ping?

My media_build tree is updated as far as:
$ git log -1
commit 0721d4bde661c71cd4e41de37afb24b0694c65a3
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Mon Nov 21 13:17:19 2016 +0100

    Only use Makefile.mm if frame_vector.c is present.

    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

> On Wed, Feb 08, 2017 at 10:30:30PM +1100, Vincent McIntyre wrote:
>> Hi
>>
>> I have been working with Sean on figuring out the protocol used by a
>> dvico remote.
>> I thought the patch he sent was at fault but I backed it out and tried
>> again.
>>
>> I've attached a full dmesg but the core of it is when dvb_usb_cxusb
>> tries to load:
>>
>> [    7.858907] WARNING: You are using an experimental version of the
>> media stack.
>>                 As the driver is backported to an older kernel, it doesn't
>> offer
>>                 enough quality for its usage in production.
>>                 Use it with care.
>>                Latest git patches (needed if you report a bug to
>> linux-media@vger.kernel.org):
>>                 47b037a0512d9f8675ec2693bed46c8ea6a884ab [media]
>> v4l2-async: failing functions shouldn't have side effects
>>                 79a2eda80c6dab79790c308d9f50ecd2e5021ba3 [media]
>> mantis_dvb: fix some error codes in mantis_dvb_init()
>>                 c2987aaf0c9c2bcb0d4c5902d61473d9aa018a3d [media]
>> exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT
>> [    7.861968] dvb_usb_af9035 1-4:1.0: prechip_version=83
>> chip_version=02 chip_type=9135
>> [    7.887476] dvb_usb_cxusb: disagrees about version of symbol
>> dvb_usb_generic_rw
>> [    7.887477] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_rw (err -22)
>

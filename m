Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34600 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbbA3ROO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 12:14:14 -0500
Received: by mail-ie0-f177.google.com with SMTP id vy18so4781017iec.8
        for <linux-media@vger.kernel.org>; Fri, 30 Jan 2015 09:14:13 -0800 (PST)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com. [209.85.213.174])
        by mx.google.com with ESMTPSA id ie15sm1435341igb.12.2015.01.30.09.14.13
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jan 2015 09:14:13 -0800 (PST)
Received: by mail-ig0-f174.google.com with SMTP id b16so4749857igk.1
        for <linux-media@vger.kernel.org>; Fri, 30 Jan 2015 09:14:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <32395.1422623364@turing-police.cc.vt.edu>
References: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<21497.1422569560@turing-police.cc.vt.edu>
	<20150130130001.GZ6456@mwanda>
	<32395.1422623364@turing-police.cc.vt.edu>
Date: Fri, 30 Jan 2015 18:06:33 +0100
Message-ID: <CAKXHbyN+CmAm3x6XU9nKDMFsShGX90NsZw5emQ+ZfWovmnCOXQ@mail.gmail.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null
 pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Valdis.Kletnieks@vt.edu
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Gulsah Kose <gulsah.1004@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-01-30 14:09 GMT+01:00  <Valdis.Kletnieks@vt.edu>:
> On Fri, 30 Jan 2015 16:00:02 +0300, Dan Carpenter said:
>
>> > > - if (ir == NULL) {
>> > > -         dev_err(ir->l.dev, "close: no private_data attached to the file
> !\n");
>> >
>> > Yes, the dev_err() call is an obvious thinko.
>> >
>> > However, I'm not sure whether removing it entirely is right either.  If
>> > there *should* be a struct IR * passed there, maybe some other printk()
>> > should be issued, or even a WARN_ON(!ir), or something?
>>
>> We set filep->private_data to non-NULL in open() so I don't think it can
>> be NULL here.
>
> Then probably the *right* fix is to remove the *entire* if statement, as
> we can't end up doing the 'return -ENODEV'....


Hi

Ok, but think or know. Who knows?
Do the remove if patch?


Kind regards
Rickard Strandqvist

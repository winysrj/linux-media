Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41491 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab0JHVJC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Oct 2010 17:09:02 -0400
Received: by iwn6 with SMTP id 6so800404iwn.19
        for <linux-media@vger.kernel.org>; Fri, 08 Oct 2010 14:09:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Oct 2010 22:09:00 +0100
Message-ID: <AANLkTikdLKmfSr1bZKcTf0i=m5hzSTPSofrH_fc4mBbn@mail.gmail.com>
Subject: Passing info from main dev to subdev
From: Daniel Drake <dsd@laptop.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

The cafe_ccic + ov7670 combination is currently broken in mainstream
on the OLPC XO-1 laptop because of it's move to i2c (2bf7de4), in
order to work on the new XO-1.5 laptop. The smbus IO code was brought
back in 467142093 but this code is never triggered - CONFIG_OLPC_XO_1
doesn't exist.

I would like to do this at runtime, since we should aim to have a
kernel that can run on both XO-1 and XO-1.5.
So, I would like ov7670 to support both methods (i2c and smbus) and
for the parent device (cafe_ccic on XO-1, via-camera on XO-1.5) to
declare which one to use.

So my question: how can I communicate such info from parent to subdev?
Just the value of 1 variable would be enough.

Thanks,
Daniel

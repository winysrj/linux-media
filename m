Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZLROFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 09:05:08 -0500
Received: by ewy19 with SMTP id 19so1517250ewy.21
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 06:05:07 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 18 Dec 2009 14:05:05 +0000
Message-ID: <59cf47a80912180605o41708efao769d09d46b20a87e@mail.gmail.com>
Subject: Adaptec VideOh! DVD Media Center
From: Paulo Assis <pj.assis@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm currently porting the GPL linux-avc2210k driver (
http://www.freelists.org/archive/linux-avc2210k/ ) to V4L2.
The current version has it's own API that makes it incompatible with
any software except for specific user space apps (avcctrl, avctune)
bundled with the driver.
Since development seems to have halted for some time now, I had no
other choice than get my hands dirty :(
For the most part this task seems quite straight forward it's mostly a
matter of changing ioctls to V4L2 and add some missing support, there
are however a few points that I need some advice on:
For the box to function it needs a firmware upload. Currently this is
managed by a udev script that in turn calls an application (multiload)
that provides for the upload.
What I would like to know is, if this the best way to handle it?
The problem with this process is that it will always require
installing and configuring additional software (multiload and udev
script), besides the firmware.
Is there any simpler/standard way of handling these firmware uploads ?

Regards,
Paulo

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42393 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbBZKJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 05:09:14 -0500
Received: by iecrp18 with SMTP id rp18so12681410iec.9
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 02:09:13 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 26 Feb 2015 11:09:13 +0100
Message-ID: <CAPW4HR3+_zK0n1_djM2qd-Zxk-yrfn2GwTOrQjbLGEoYvNb0UQ@mail.gmail.com>
Subject: Media Controller for i.MX6 IPU
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I am testing your implementation of MC for the i.MX6 IPU:

git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media

I made the changes for get working my sensor, all is registering well
but I can't understand the last links in media controller. Why IPU
SMFC and imx-ipuv3-camera entities have not got format?

I can't capture nothing if I have not got format. I don't understand
how you captured with these entities.
I understand the repo is WIP but I want to reproduce the capture.

Thanks,

Carlos

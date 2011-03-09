Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55523 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab1CIKMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 05:12:49 -0500
Received: by iyb26 with SMTP id 26so343778iyb.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 02:12:48 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 11:12:48 +0100
Message-ID: <AANLkTinsKCWHMeiG=EzjUR3O2pSUEUThJX8Q1BF2ZtH9@mail.gmail.com>
Subject: v4l2 saa7134
From: =?ISO-8859-1?Q?Norbert_Pl=F3t=E1r?= <plotter008@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 Is there anybody, who knows, how, the v4l2 saa7134 part works in kernel space?
 I mean I have a gt-p8000 tv card. It's a hybrid tuner.
 I started to modify the saa7134 driver, but I cannot see the control
flaw, the call order.
 Furthermore I would like to debug my code like only switching a GPIO
on a single chip.
 My card contains the following chips:

  saa7131e/03/g
  tda18271hd
  tda10048hn

 My future plan to create a gui, and control the 3 chips separately.
But first of all, to make it work as a TV card on linux.

Thanks.
BR,
Norbert

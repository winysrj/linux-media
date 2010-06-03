Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.211.179]:42651 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab0FCP24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 11:28:56 -0400
Received: by ywh9 with SMTP id 9so266008ywh.17
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 08:28:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Jun 2010 18:28:54 +0300
Message-ID: <AANLkTin5aDjdLQ4W0FJc6Te9E_HOCV9dz8DnGdrA-Voq@mail.gmail.com>
Subject: Terratec Cinergy C DVB-C card problems
From: Billy Brumley <bbrumley@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got a terratec cinergy c dvb-c card, fresh install of ubuntu
10.04 lucid i386. Card is here:

http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C

I followed the install instructions under "Driver", installing the one from

http://mercurial.intuxication.org/hg/s2-liplianin

dmesg output afterwards:

http://dpaste.com/202745/

and lsmod/lspci:

http://dpaste.com/202150/

The previous install that worked nicely was hardy, using
mantis-a9ecd19a37c9 that refused to compile with lucid's more recent
kernel. Any ideas?

Billy

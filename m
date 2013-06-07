Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55038 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3FGXXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 19:23:08 -0400
Received: by mail-wg0-f52.google.com with SMTP id z12so2872199wgg.31
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 16:23:05 -0700 (PDT)
Received: from [192.168.1.14] ([176.61.122.125])
        by mx.google.com with ESMTPSA id ft10sm823359wib.7.2013.06.07.16.23.04
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Jun 2013 16:23:04 -0700 (PDT)
Message-ID: <51B26B2C.7090406@gmail.com>
Date: Sat, 08 Jun 2013 01:22:20 +0200
From: Rodrigo Tartajo <rtarty@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RE: rtl28xxu IR remote
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I just compiled and tested Antti Palosaari branch and can confirm the remote works for my RTL2832U. I have updated the wiki[1] entry with the steps necessary to configure the remote control. Please confirm if these fixes your problem.

Rodrigo.

[1] http://www.linuxtv.org/wiki/index.php/RealTek_RTL2832U

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1LVXnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 18:43:24 -0500
Received: by eaad14 with SMTP id d14so2375701eaa.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 15:43:23 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 23 Dec 2011 00:43:22 +0100
Message-ID: <CAEN_-SD3ap9VM_9aP7L3fGzJT_EfApEP5o4-wUmcUcXe5JvQJw@mail.gmail.com>
Subject: Read DVB signal information directly from xc4000 based tuners
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For xc4000 based tuners we can read signal directly from tuner even
for demodulator. This is updated patch of id 8933. This patch depends
on id 8926 (Add signal information to xc4000 tuner).

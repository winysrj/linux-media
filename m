Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:28732 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZCHJIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 05:08:45 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1179788rvb.1
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2009 01:08:43 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Mar 2009 19:08:43 +1000
Message-ID: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
Subject: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop building
From: Peter Baartz <baartzy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI,

I have Dvico dual 4 DVB-T card (rev. 2), which  wants to use the
module dvb_usb_cxusb.

When i attempt  build http://linuxtv.org/hg/v4l-dvb, make no longer
builds cxusb...

The  Kconfig: commits appear to have caused this... i.e. cxusb build
fine when using  "changeset 10834	277d533e87cd"  (it's just prior  to
Kconfig: commits )  from hg/v4l-dvb.

Thanks,
Peter






..

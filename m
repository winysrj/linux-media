Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:63715 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0BHPmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 10:42:19 -0500
Received: by pzk2 with SMTP id 2so358835pzk.21
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 07:42:18 -0800 (PST)
Message-ID: <4B7030C5.6000303@gmail.com>
Date: Mon, 08 Feb 2010 15:41:57 +0000
From: Richard <tuxbox.guru@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TM6000 Driver building
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Pardon my green-ness to the whole process of the v4l-dvb and would like 
some pointers on how to build the TM6000 components of the drivers

in v4l/ directtory I edited the .config to enable the TM6000_DVB=m 
clause and rebuilt.. but lo and behold there were still no modules 
built.. I am trying to hack on the WinTV-NOVA-S USB2 device and register 
it as a Generic TM6000 to start my porting.

Is there a special branch or a quick 'howto' so I can enable this module


Any help would be greatly appreciated.
Richard

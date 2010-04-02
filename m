Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39904 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0DBOPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 10:15:12 -0400
Received: by vws13 with SMTP id 13so551854vws.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 07:15:11 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Apr 2010 08:15:11 -0600
Message-ID: <y2w994f7fe91004020715o18226cfdt565a7f40582e537a@mail.gmail.com>
Subject: em28xx vbi read timeout
From: Tim Stowell <stowellt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a KWorld usb 2800D device and am using the newest em28xx
v4l-dvb drivers from linuxtv.org. I'm running Gentoo with a 2.6.31
kernel. The driver compiles fine, and then I issue the following
commands:

v4lctl setnorm NTSC
zvbi-ntsc-cc -c -d /dev/vbio -v


after that I just get constant "VBI Read Timeout (Ignored)" messages.
Any help is greatly appreciated. (I initially posted this question to
the kernellabs blog, I apologize I didn't know there was a mailing
list at the time, so I'm posting my question here now.) Thanks

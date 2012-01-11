Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62778 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab2AKLa4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 06:30:56 -0500
Received: by wgbds12 with SMTP id ds12so454357wgb.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 03:30:55 -0800 (PST)
Message-ID: <4F0D72F1.8070806@gmail.com>
Date: Wed, 11 Jan 2012 11:30:57 +0000
From: Jim Darby <uberscubajim@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <4F0CE040.7020904@iki.fi>
In-Reply-To: <4F0CE040.7020904@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I thought I'd batch all the answers together.

Andy suggested something about transfer buffers being dropped out of 
rotation. I'm not sure exactly what this is but if it's anything like 
ethernet buffering it would explain it. It would also explain why it 
lasts longer on the lower bit rate standard definition TV rather than HDTV.

In response to Antti's question, I have indeed tested kernel 3.1.6. This 
was where I originally noticed the problem. I upgraded to 3.2.0 to see 
if had been fixed and when I found that it hadn't posted here.

I pulled the LinuxTV.org v4l-dvb from mercurial but it looks more like a 
patch than a full kernel (the previous one I pulled seven months ago was 
a complete kernel). For reference the 3.0.0+ kernel that came from 
LinuxTV.org v4l-dvb seven months ago has functioned flawlessly ever since.

I've just downloaded the media_build.git stuff, installed the extra 
packages it needed and it's be building now.

The other card in the system is a very old Nova-T. It's got a LSI L64781 
frontend on it.

Finally Steven said that it might be signal, hardware or heat related. 
I'm unsure of this because if I boot the machine with the 3.0.0+ kernel 
with exactly the same user-land everything it functions perfectly and 
has done for months.

I'll report back on my adventures with the media_build changes to the 
3.2 kernel.

Best regards,

Jim.

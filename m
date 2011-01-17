Return-path: <mchehab@pedra>
Received: from mout.perfora.net ([74.208.4.195]:53744 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1AQXNQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 18:13:16 -0500
Message-ID: <4D34CCF6.5040603@vorgon.com>
Date: Mon, 17 Jan 2011 16:12:54 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
References: <20101207190753.GA21666@io.frii.com>
In-Reply-To: <20101207190753.GA21666@io.frii.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I just tried to update from kernel 2.6.34 and in doing so had to switch 
to git for v4l. I noticed the chip in this this post and saved it to 
look at latter. now I'm glad I did. I ran into the same problem. Driver 
seems to load ok, but when I try to start vdr I get thet same messages 
in syslog.

Jan 16 21:50:48 LLLx64-32 vdr: [6170] saved setup to 
/usr/local/dvb/VDR/config/setup.conf
Jan 16 21:50:49 LLLx64-32 kernel: xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
Jan 16 21:50:49 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
Jan 16 21:50:49 LLLx64-32 kernel: xc5000: firmware uploading...
Jan 16 21:50:49 LLLx64-32 vdr: [6176] section handler thread ended 
(pid=6170, tid=6176)
Jan 16 21:50:49 LLLx64-32 kernel: xc5000: I2C write failed (len=3)
Jan 16 21:50:49 LLLx64-32 kernel: xc5000: firmware upload complete...
Jan 16 21:50:50 LLLx64-32 vdr: [6175] tuner on frontend 0/0 thread ended 
(pid=6170, tid=6175)
Jan 16 21:50:50 LLLx64-32 kernel: xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
Jan 16 21:50:50 LLLx64-32 kernel: xc5000: firmware read 12401 bytes.
Jan 16 21:50:50 LLLx64-32 kernel: xc5000: firmware uploading...
Jan 16 21:50:50 LLLx64-32 vdr: [6174] CI adapter on device 0 thread 
ended (pid=6170, tid=6174)
.......

On 12/7/2010 12:07 PM, Mark Zimmerman wrote:
> Greetings:
>
> I have a DViCO FusionHDTV7 Dual Express card that works with 2.6.35 but
> which fails to initialize with the latest 2.6.36 kernel. The firmware
> fails to load due to an i2c failure. A search of the archives indicates
> that this is not the first time this issue has occurred.
>
> What can I do to help get this problem fixed?
>
> Here is the dmesg from 2.6.35, for the two tuners:
>
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> xc5000: firmware read 12401 bytes.
> xc5000: firmware uploading...
> xc5000: firmware upload complete...
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> xc5000: firmware read 12401 bytes.
> xc5000: firmware uploading...
> xc5000: firmware upload complete..
>
> and here is what happens with 2.6.36:
>
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> xc5000: firmware read 12401 bytes.
> xc5000: firmware uploading...
> xc5000: I2C write failed (len=3)
> xc5000: firmware upload complete...
> xc5000: Unable to initialise tuner
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> xc5000: firmware read 12401 bytes.
> xc5000: firmware uploading...
> xc5000: I2C write failed (len=3)
> xc5000: firmware upload complete...
>
> -- Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy002.phy.lolipop.jp ([157.7.104.43]:35326 "EHLO
	smtp-proxy002.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbcFLEaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 00:30:30 -0400
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
To: Henrik Austad <henrik@austad.us>, alsa-devel@alsa-project.org
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <575CD93C.50006@sakamocchi.jp>
Cc: netdev@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@vger.kernel.org, henrk@austad.us
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Message-ID: <575CE560.9090608@sakamocchi.jp>
Date: Sun, 12 Jun 2016 13:30:24 +0900
MIME-Version: 1.0
In-Reply-To: <575CD93C.50006@sakamocchi.jp>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jun 12 2016 12:38, Takashi Sakamoto wrote:
> In your patcset, there's no actual codes about how to handle any
> interrupt contexts (software / hardware), how to handle packet payload,
> and so on. Especially, for recent sound subsystem, the timing of
> generating interrupts and which context does what works are important to
> reduce playback/capture latency and power consumption.
> 
> Of source, your intention of this patchset is to show your early concept
> of TSN feature. Nevertheless, both of explaination and codes are
> important to the other developers who have little knowledges about TSN,
> AVB and AES-64 such as me.

Oops. Your 5th patch was skipped by alsa-project.org. I guess that size
of the patch is too large to the list service. I can see it:
http://marc.info/?l=linux-netdev&m=146568672728661&w=2

As long as seeing the patch, packets are queueing in hrtimer callbacks
every 1 seconds.

(This is a high level discussion and it's OK to ignore it for the
moment. When writing packet-oriented drivers for sound subsystem, you
need to pay special attention to accuracy of the number of PCM frames
transferred currently, and granularity of the number of PCM frames
transferred by one operation. In this case, snd_avb_hw,
snd_avb_pcm_pointer(), tsn_buffer_write_net() and tsn_buffer_read_net()
are involved in this discussion. You can see ALSA developers' struggle
in USB audio device class drivers and (of cource) IEC 61883-1/6 drivers.)


Regards

Takashi Sakamoto

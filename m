Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:47461 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab1LAOad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 09:30:33 -0500
Message-ID: <4ED78F85.7020005@linuxtv.org>
Date: Thu, 01 Dec 2011 15:30:29 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: Support for multiple section feeds with same PIDs
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org> <000301ccb030$dfaa71f0$9eff55d0$@org> <4ED787D5.203@linuxtv.org> <000401ccb034$a8ec2ce0$fac486a0$@org>
In-Reply-To: <000401ccb034$a8ec2ce0$fac486a0$@org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.12.2011 15:22, Hamad Kadmany wrote:
> Hello Andreas
> 
> On 01.12.2011 15:58, Andreas Oberritter wrote:
> 
>> No. dvb_demux will do the extra filtering. Userspace won't notice.
> 
> Got it now, thanks. The one downside I see to this is that the feed will be
> stopped momentarily (dvb_dmxdev_feed_stop) before new filter is allocated
> that have the same PID.

Yes. Feel free to enhance the demux API to your needs in order to fully
support the features of your hardware.

Regards,
Andreas

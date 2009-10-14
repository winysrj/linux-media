Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:33384 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221AbZJNLCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 07:02:36 -0400
Message-ID: <4AD5AFA6.8080401@onelan.com>
Date: Wed, 14 Oct 2009 12:01:58 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-media@vger.kernel.org
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
References: <4AD591BB.80607@onelan.com> <1255516547.3848.10.camel@palomino.walls.org>
In-Reply-To: <1255516547.3848.10.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Have your remote user read
> 
> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
> 
> and take any actions that seem appropriate/easy.
> 
I'll try that again - they're grouching, because their TV is fine, and
the same card in a Windows PC is also fine. It's just under Linux that
they're seeing problems, so I may not be able to get them to co-operate.
> 
> The in kernel mxl5005s driver is known to have about 3 dB worse
> performance for QAM vs 8-VSB (Steven Toth took some measurements once).
> 
Am I misunderstanding dmesg here? I see references to a Samsung S5H1409,
not to an mxl5005s; if I've read the driver code correctly, I'd see a
KERN_INFO printk for the mxl5005s when it comes up.
-- 
Simon Farnsworth


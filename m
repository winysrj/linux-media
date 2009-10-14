Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55605 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358AbZJNKdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 06:33:37 -0400
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
From: Andy Walls <awalls@radix.net>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4AD591BB.80607@onelan.com>
References: <4AD591BB.80607@onelan.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 06:35:47 -0400
Message-Id: <1255516547.3848.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-10-14 at 09:54 +0100, Simon Farnsworth wrote:
> Hello,
> 
> I'm having problems with glitchy reception on a HVR-1600 card using
> ClearQAM digital cable channels. Unfortunately, I'm remote from the box,
> so can't describe the visual appearance, but I do have SSH access.
> 
> Looking at the output of femon -c 100 (attached as femon.txt), I'm
> seeing the occasional burst of UNC errors. I've attached dmesg as
> dmesg.txt in case it gives any clues; the v4l drivers are as in kernel
> 2.6.30 from Linus, with no extra patches.
> 
> I'm using Xine to decode the channel - my channels.conf line for the
> channel in question is:
> WTAE:567012500:QAM_256:0:0:5
> 
> Any ideas?

Have your remote user read

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

and take any actions that seem appropriate/easy.


The in kernel mxl5005s driver is known to have about 3 dB worse
performance for QAM vs 8-VSB (Steven Toth took some measurements once).

If I had access to the mxl5005s datasheet and any programming manuals, I
could probably fix this.  However, I do not have them.  Though, I have
not asked MaxLinear for them either since I don't have cable at my home
(yet).

Regards,
Andy


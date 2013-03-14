Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3127 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3CNHom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 03:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Benjamin Schindler <beschindler@gmail.com>
Subject: Re: msp3400 problem in linux-3.7.0
Date: Thu, 14 Mar 2013 08:44:37 +0100
Cc: linux-media@vger.kernel.org
References: <51410709.5040805@gmail.com> <201303140757.10555.hverkuil@xs4all.nl> <51417899.2070201@gmail.com>
In-Reply-To: <51417899.2070201@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303140844.37378.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu March 14 2013 08:13:29 Benjamin Schindler wrote:
> Hi Hans
> 
> Thank you for the prompt response. I will try this once I'm home again.
> Which patch is responsible for fixing it? Just so I can track it once it
> lands upstream.

There is a whole series of bttv fixes that I did that will appear in 3.10.

But the patch that is probably responsible for fixing it is this one:

http://git.linuxtv.org/media_tree.git/commit/76ea992a036c4a5d3bc606a79ef775dd32fd3daa

I say 'probably' because I am not 100% certain that that is the main fix.
I'm 99% certain, though :-)

As mentioned, it was part of a much longer patch series, so there may be other
patches involved in this particular problem, but I don't think so.

If you can perhaps test just that single patch then that would be useful
information. If that fixes the problem then that's a candidate for 'stable'
kernels.

> I have one more question - the wiki states the the WinTV-HVR-5500 is not
> yet supported (as of June 2011) - is there an update on this? It's the
> only DVB-C card I can buy in the local stores here

No idea. I do V4L2, not DVB :-) Hopefully someone else knows.

Regards,

	Hans

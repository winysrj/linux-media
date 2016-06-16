Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59109 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcFPBhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 21:37:22 -0400
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Jack Mitchell <ml@embed.me.uk>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <576202D0.6010608@mentor.com>
Date: Wed, 15 Jun 2016 18:37:20 -0700
MIME-Version: 1.0
In-Reply-To: <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jack,

On 06/15/2016 03:43 AM, Jack Mitchell wrote:
> <snip>
> Trying to use a user pointer rather than mmap also fails and causes a kernel splat.
>

Hmm, I've tested userptr with the mem2mem driver, but maybe never
with video capture. I tried "v4l2-ctl -d/dev/video0 --stream-user=8" but
that returns "VIDIOC_QBUF: failed: Invalid argument", haven't tracked
down why (could be a bug in v4l2-ctl). Can you share the splat?


> Apart from that and a few v4l2-compliance tests failing which you already mentioned, it seems to work OK. I'll try and do some more testing and see if I can come back with some more feedback.

Thanks!


Steve


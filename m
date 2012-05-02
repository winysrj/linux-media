Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2EBLiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:38:16 -0400
Received: by eaaq12 with SMTP id q12so137201eaa.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 04:38:14 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 07/10] dvb-demux: add functionality to send raw payload to the dvr device
Date: Wed, 2 May 2012 13:38:09 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org> <1335845545-20879-7-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-7-git-send-email-mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021338.09817.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Tuesday 01 May 2012 06:12:22 Michael Krufky wrote:
> From: Michael Krufky <mkrufky@kernellabs.com>
> 
> If your driver needs to deliver the raw payload to userspace without
> passing through the kernel demux, use function: dvb_dmx_swfilter_raw

I like this one very much. I had a background task sleeping in my head 
which was how to add non-Transport-Stream standards to Linux-dvb. This 
one I can now cancel, thanks to this change.

We now can add CMMB-support and DAB to linux-dvb (after more discussions 
on the API of course).

Do you have user-space-tool ready which uses the new RAW-payload 
mechanism? Something which can be used as an example.

Thanks for this development.

--
Patrick 

Kernel Labs Inc.
http://www.kernellabs.com/

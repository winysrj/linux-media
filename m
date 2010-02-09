Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:62858 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0BIPmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 10:42:35 -0500
Received: by bwz23 with SMTP id 23so286523bwz.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 07:42:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7166A5.8050402@cooptel.qc.ca>
References: <4B70E7DB.7060101@cooptel.qc.ca>
	 <829197381002082118k346437b3y4dc2eb76d017f24f@mail.gmail.com>
	 <4B7166A5.8050402@cooptel.qc.ca>
Date: Tue, 9 Feb 2010 10:42:33 -0500
Message-ID: <829197381002090742m1975641eta54b9169447b0436@mail.gmail.com>
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
	(DVB-S) and USB HVR Hauppauge 950q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Richard Lemieux <rlemieu@cooptel.qc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2010 at 8:44 AM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
> Hi Devin,
>
> I was previously running kernel vmlinux-2.6.29.5.  I notice there was a
> major
> reorganization of some of the media structure between 2.6.29 and 2.6.32.
> Can you tell me at wich kernel version the change occured so I can start
> from there.

Hi Richard,

The only "major reorganization" in that time period I can think of is
a couple of the files related to IR support were moved.

Further, the problem appears to be in the implementation of
request_firmware() and doesn't look specific to any changes in the
v4l-dvb tree.

All I can suggest at this point is you try to narrow down what release
the breakage was introduced in, at which point we can take a look at
what changed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

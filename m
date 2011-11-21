Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1KUOF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 09:05:58 -0500
Received: by fagn18 with SMTP id n18so5970983fag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 06:05:56 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Jos Lemmens <jos@jlemmens.nl>
Subject: Re: Nova-T Stick 2 on kernel 3.0
Date: Mon, 21 Nov 2011 15:08:27 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20111121131425.GA14204@jlemmens.nl>
In-Reply-To: <20111121131425.GA14204@jlemmens.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111211508.27391.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jos,

On Monday 21 November 2011 14:14:25 Jos Lemmens wrote:
> Hello Patrick,
> 
> I have a Device 008: ID 2040:7060 Hauppauge Nova-T Stick 2 dvb
> adapter. It worked great with your driver in Linux kernel 2. But
> since kernel 3.0 it doesn't work anymore. When I try to start the tv
> with the tzap tool, I get this message:
> 
>    dib0700: tx buffer length is larger than 4. Not supported.

Oh, I wasn't aware that this problem exists (or I forgot). If you can 
please try a newer version of the kernel. Or try the media_build + the 
v4l-dvb-repository to track down (via git bisect, for example) which 
commit broke it. What was the latest version you have tried?

Anyone else confirms this problem?

--
Patrick

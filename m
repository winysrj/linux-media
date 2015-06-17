Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34881 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbFQV7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 17:59:03 -0400
Received: by qkbp125 with SMTP id p125so29974084qkb.2
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2015 14:59:03 -0700 (PDT)
Date: Wed, 17 Jun 2015 18:58:21 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernel-mentors@selenic.com,
	Linux Media <linux-media@vger.kernel.org>,
	OSUOSL Drivers <devel@driverdev.osuosl.org>
Subject: Re: solo6x10: all interrupts for all cards handled by CPU0, no
 balancing - why?
Message-ID: <20150617185821.3d043611@pirotess>
In-Reply-To: <CANZNk81pQojKfaydmfwp7EDKyd5p3eE9DhHHJZ_UHmwxeb29qQ@mail.gmail.com>
References: <CANZNk81X8egiGgnupeRVo9HPStH3rRcPdLYWQifcHKnOLUMivg@mail.gmail.com>
	<CANZNk81pQojKfaydmfwp7EDKyd5p3eE9DhHHJZ_UHmwxeb29qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jan 2015 00:29:13 +0200
Andrey Utkin <andrey.krieger.utkin@gmail.com> wrote:
> The host was rebooted and got back online.
> Without irqbalance daemon, all solo6x10 interrupts are still on CPU0.
> See https://gist.github.com/krieger-od/d1686243c67fbe3e14a5
> Any ideas are strongly appreciated.
> 

My understanding was that balancing happened by package, not by core,
but my knowledge might be outdated...

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:34908 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbZBODlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 22:41:09 -0500
Subject: Re: saa7134-alsa does not compile (BUG?)
From: hermann pitton <hermann-pitton@arcor.de>
To: Jakob Sundberg <lists@orresta.no-ip.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4997482D.2000103@orresta.no-ip.com>
References: <4997482D.2000103@orresta.no-ip.com>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 04:42:12 +0100
Message-Id: <1234669332.2704.13.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakob,

Am Samstag, den 14.02.2009, 23:39 +0100 schrieb Jakob Sundberg:
> Hi,
> 
> I upgraded my kernel and recompiled v4l-dvb to match the new kernel. Now 
> the saa7134-alsa kernel module is no more. What did I do wrong?
> 

we try to support vanilla kernels from 2.6.16 to the latest 2.6.29
release candidate.

We even try to support distribution kernels when ever we can.

If they use something for alsa for example, even not yet in a vanilla
kernel, they are going out of our scope and have to fix the breakages
they introduce themselves.

Given that, your report without any details is completely useless.

Cheers,
Hermann




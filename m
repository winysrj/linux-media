Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49371 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2AJN27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 08:28:59 -0500
Received: by wgbdt14 with SMTP id dt14so2613473wgb.1
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 05:28:58 -0800 (PST)
Message-ID: <4F0C3D1B.2010904@gmail.com>
Date: Tue, 10 Jan 2012 13:28:59 +0000
From: Jim Darby <uberscubajim@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been using a PCTV Nanostick T2 USB DVB-T2 receiver (one of the few 
that supports DVB-T2) for over six months with a 3.0 kernel with no 
problems.

The key drivers in use are em28xx, cxd2820r and tda18271.

Seeing the 3.2 kernel I thought I'd upgrade and now I seem to have hit a 
problem.

The Nanostick works fine for between 5 and 25 minutes and then without 
any error messages cuts out. The TS drops to a tiny stream of non-TS 
data. It seems to contain a lot of 0x00s and 0xffs.

It looks like the problem of many years ago when the frontends would be 
shut down if they were closed for more than a few minutes. However, it 
would appear that the frontend fds are still open (according to fuser).

Some more system details:

This is running on a 32-bit system.

Everything works fine if I boot with the 3.0.0 kernel.

The user-land application is kaffeine.

There is a PCI DVB-T card in the system which operates fine even when 
the Nanostick stops producing the correct output.

I'm more than happy to build kernels and add debugging. I'm basically 
just trying to find the maintainer for these modules so we can figure 
out what's going wrong and fix it before 3.2 escapes into several 
distros and we have this problem on a larger scale.

Many thanks for your help,

Jim.

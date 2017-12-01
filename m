Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.grimmerink.nl ([84.245.15.195]:60455 "EHLO
        mx1.grimmerink.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbdLALqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 06:46:17 -0500
Received: from [192.168.1.13] (mx1.grimmerink.nl [84.245.15.195])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mx1.grimmerink.nl (Postfix) with ESMTPSA id 4775B6A12F
        for <linux-media@vger.kernel.org>; Fri,  1 Dec 2017 12:38:15 +0100 (CET)
To: linux-media@vger.kernel.org
From: pieterg <pieterg@gmx.com>
Subject: multiple frontends on a single dvb adapter
Message-ID: <2a083a5e-a3dd-6225-4201-a4d62333fcfa@gmx.com>
Date: Fri, 1 Dec 2017 12:38:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The recent removal of DMX_SET_SOURCE

https://github.com/torvalds/linux/commit/13adefbe9e566c6db91579e4ce17f1e5193d6f2c

and earlier removal of the set_source callback

https://github.com/torvalds/linux/commit/1e92bbe08ad9fc0d5ec05174c176a9bc54921733

leads to the question how the situation of having multiple frontends on
a single dvb adapter should be handled nowadays.
Suppose the routing is flexible, any demux could be sourced by any frontend.
In the past, this has been achieved by using the set_source callback,
allowing userspace to configure the routing by using the DMX_SET_SOURCE
ioctl.

The connect_frontend / disconnect_frontend callbacks are currently only
called for the memory frontend, so it seems no longer possible to select
hardware frontends.
How do you guys see this, what does the standard dictate in this case?
Should we assume a 1:1 mapping between frontendN:demuxN and forbid
dynamic routing? Or am I overlooking something?

In my opinion, supporting dynamic routing would be an advantage.
Especially when the number of (hardware) demuxes is smaller than the
number of (hardware) frontends.

Regards,
Pieter

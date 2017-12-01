Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35896 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbdLALzj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 06:55:39 -0500
Received: by mail-qk0-f171.google.com with SMTP id t187so12797201qkh.3
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 03:55:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2a083a5e-a3dd-6225-4201-a4d62333fcfa@gmx.com>
References: <2a083a5e-a3dd-6225-4201-a4d62333fcfa@gmx.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 1 Dec 2017 12:55:38 +0100
Message-ID: <CAJbz7-0xYqCPR1OG+B80s+08hshF5XJbcPxD1DgDTZp19a=OPw@mail.gmail.com>
Subject: Re: multiple frontends on a single dvb adapter
To: pieterg <pieterg@gmx.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-12-01 12:38 GMT+01:00 pieterg <pieterg@gmx.com>:
> Hi,
>
> The recent removal of DMX_SET_SOURCE
>
> https://github.com/torvalds/linux/commit/13adefbe9e566c6db91579e4ce17f1e5193d6f2c
>
> and earlier removal of the set_source callback
>
> https://github.com/torvalds/linux/commit/1e92bbe08ad9fc0d5ec05174c176a9bc54921733
>
> leads to the question how the situation of having multiple frontends on
> a single dvb adapter should be handled nowadays.
> Suppose the routing is flexible, any demux could be sourced by any frontend.
> In the past, this has been achieved by using the set_source callback,
> allowing userspace to configure the routing by using the DMX_SET_SOURCE
> ioctl.
>
> The connect_frontend / disconnect_frontend callbacks are currently only
> called for the memory frontend, so it seems no longer possible to select
> hardware frontends.
> How do you guys see this, what does the standard dictate in this case?
> Should we assume a 1:1 mapping between frontendN:demuxN and forbid
> dynamic routing? Or am I overlooking something?
>
> In my opinion, supporting dynamic routing would be an advantage.
> Especially when the number of (hardware) demuxes is smaller than the
> number of (hardware) frontends.


It was already discussed with Mauro, when me (and may be some others
complained about such removals).

The rule is simple - if you have HW with multiple frontends, then you can
provide patch and revive the old stuffs.

Mauro's POV is = no user of such callbacks/ioctl means removal of that.

/Honza

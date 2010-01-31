Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f193.google.com ([209.85.210.193]:59399 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0AaPXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 10:23:14 -0500
Received: by yxe31 with SMTP id 31so3256010yxe.21
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 07:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
Date: Sun, 31 Jan 2010 16:23:12 +0100
Message-ID: <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
Subject: Re: CAM appears to introduce packet loss
From: Marc Schmitt <marc.schmitt@gmail.com>
To: Abylai Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks like I need to build the DVB subsystem from the latest sources
to get this option as it was recently added only
(http://udev.netup.ru/cgi-bin/hgwebdir.cgi/v4l-dvb-aospan/rev/1d956b581b02).
On it.

On Sun, Jan 31, 2010 at 4:07 PM, Marc Schmitt <marc.schmitt@gmail.com> wrote:
> What do I need to do to make dvb_demux_speedcheck appear in
> /sys/module/dvb_core/parameters?

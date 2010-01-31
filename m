Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f181.google.com ([209.85.210.181]:59309 "EHLO
	mail-yx0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0AaPHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 10:07:03 -0500
Received: by yxe11 with SMTP id 11so3342593yxe.15
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 07:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264941827.28401.3.camel@alkaloid.netup.ru>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
Date: Sun, 31 Jan 2010 16:07:01 +0100
Message-ID: <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
Subject: Re: CAM appears to introduce packet loss
From: Marc Schmitt <marc.schmitt@gmail.com>
To: Abylai Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

On Sun, Jan 31, 2010 at 1:43 PM, Abylai Ospan <aospan@netup.ru> wrote:
> Hello,
>
> Try to check raw speed coming from demod:
>
> echo 1 > /sys/module/dvb_core/parameters/dvb_demux_speedcheck

What do I need to do to make dvb_demux_speedcheck appear in
/sys/module/dvb_core/parameters?

Cheers,
   Marc

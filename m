Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:38471 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752443AbZBOWzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 17:55:00 -0500
Message-ID: <49989D42.8040008@rogers.com>
Date: Sun, 15 Feb 2009 17:54:58 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO FusionHDTV7 Dual Express
References: <e32e0e5d0902051548x3023851cua78424304a09cb7e@mail.gmail.com>
In-Reply-To: <e32e0e5d0902051548x3023851cua78424304a09cb7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim Lucas wrote:
> My cable system was recently updated to time warner so I thought I
> would try to get the mythbuntu box working again.  
> I have the DViCO FusionHDTV7 Dual Express card which seems to be
> recognized by my system but I still cannot tune channels. I tried
> using tvtime and got the following error
>
> I/O error : Permission denied
> Cannot change owner of /home/lucas/.tvtime/tvtime.xml: Permission denied.
> videoinput: Cannot open capture device /dev/video0: No such file or
> directory.

Analog is currently not supported by the cx23885 driver

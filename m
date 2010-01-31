Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:47139 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab0AaPeb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 10:34:31 -0500
Subject: Re: CAM appears to introduce packet loss
From: Abylai Ospan <aospan@netup.ru>
To: Marc Schmitt <marc.schmitt@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
	 <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 18:32:55 +0300
Message-ID: <1264951975.28401.8.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-01-31 at 16:23 +0100, Marc Schmitt wrote:
> Looks like I need to build the DVB subsystem from the latest sources
> to get this option as it was recently added only
> (http://udev.netup.ru/cgi-bin/hgwebdir.cgi/v4l-dvb-aospan/rev/1d956b581b02).
> On it.
yes.

this option should show "raw" bitrate coming from demod and which passed
to CI. In user level you may be measuring bitrate after software PID
filtering ( may be not ).

-- 
Abylai Ospan <aospan@netup.ru>
NetUP Inc.


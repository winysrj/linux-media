Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2HFMWA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:22:00 -0400
Message-ID: <501FB6DC.3040200@iki.fi>
Date: Mon, 06 Aug 2012 15:21:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] az6007: handle CI during suspend/resume
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com> <1344188679-8247-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344188679-8247-4-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2012 08:44 PM, Mauro Carvalho Chehab wrote:
> The dvb-usb-v2 core doesn't know anything about CI. So, the
> driver needs to handle it by hand. This patch stops CI just
> before stopping URB's/RC, and restarts it before URB/RC start.
>
> It should be noticed that suspend/resume is not yet working properly,
> as the PM model requires the implementation of reset_resume:
> 	dvb_usb_az6007 1-6:1.0: no reset_resume for driver dvb_usb_az6007?
> But this is not implemented there at dvb-usb-v2 yet.

That is true, but it is coming:
http://blog.palosaari.fi/2012/07/dvb-power-management-on-suspend.html
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dvb_core3

At the time I added initial suspend/resume support for dvb-usb-v2 I left 
those out purposely as I saw some study and changes are needed for 
DVB-core/frontend.

Normally suspend keeps USB-device powered and calls .resume() on resume. 
But on certain conditions USB device could lose power during suspend and 
on that case reset_resume() is called, and if there is no reset_resume() 
is calls disconnect() (and probe() after that).

regards
Antti

-- 
http://palosaari.fi/

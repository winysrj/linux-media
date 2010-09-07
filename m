Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54492 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IGP62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 11:58:28 -0400
Received: by ewy23 with SMTP id 23so2426976ewy.19
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 08:58:27 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] V4L/DVB: dib7770: enable the current mirror
Date: Tue, 7 Sep 2010 17:58:24 +0200
Cc: linux-media@vger.kernel.org
References: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
In-Reply-To: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071758.24178.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Mauro,

On Tuesday 07 September 2010 17:50:45 pboettcher@kernellabs.com wrote:
> From: Olivier Grenie <olivier.grenie@dibcom.fr>
> 
> To improve performance on DiB7770-devices enabling the current mirror
> is needed.
> 
> This patch adds an option to the dib7000p-driver to do that and it
> creates a separate device-entry in dib0700-device to use those changes
> on hardware which is using the DiB7770.
> 
> Cc: stable@kernel.org
> 
> Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
> Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
> ---
>  drivers/media/dvb/dvb-usb/dib0700_devices.c |   53
> ++++++++++++++++++++++++++- drivers/media/dvb/frontends/dib7000p.c      | 
>   2 +
>  drivers/media/dvb/frontends/dib7000p.h      |    3 ++
>  3 files changed, 57 insertions(+), 1 deletions(-)

This is the patch I was talking to you about in my last Email. This one needs 
to be quickly applied to 2.6.35. Well ... quickly ... as soon as possible in  
sense of when you have a free time slot.

This patch help to optimize the performance of the DiB7770-chip which can be 
found in several devices out there right now.

It was tested and applied on 2.6.36-rc3, It should apply cleanly on 2.6.35.

Thanks in advance for your help,

Patrick.

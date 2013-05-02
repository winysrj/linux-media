Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743Ab3EBQZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 12:25:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Subject: Re: [PATCH, RFC 22/22] radio-si4713: depend on SND_SOC
Date: Thu, 2 May 2013 18:25:11 +0200
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-23-git-send-email-arnd@arndb.de> <CAC-25o9Xp+pu_AUwxyh+YsiOCOebzMRF37v1VWZJD6nrbx5e6Q@mail.gmail.com>
In-Reply-To: <CAC-25o9Xp+pu_AUwxyh+YsiOCOebzMRF37v1VWZJD6nrbx5e6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021825.12094.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 May 2013, edubezval@gmail.com wrote:
> On Thu, May 2, 2013 at 11:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > It is not possible to select SND_SOC_SI476X if we have not also
> > enabled SND_SOC.
> >
> > warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet
> >          direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC)
> >
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> Note on your patch title, this change is against si476X, not on *si4713*.
> 

Sorry about that, I must have copied the wrong prefix from an older patch
then. I'll fix it up locally in case I need to resend.

	Arnd

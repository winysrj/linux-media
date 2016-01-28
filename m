Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33511 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcA1TdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 14:33:06 -0500
Received: by mail-yk0-f179.google.com with SMTP id k129so43570501yke.0
        for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 11:33:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AA6A2A.1020801@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<2d2392f96a7f10a8d94a4d7fa6d5657b56b75593.1452105878.git.shuahkh@osg.samsung.com>
	<20160128135752.536e909e@recife.lan>
	<56AA6A2A.1020801@osg.samsung.com>
Date: Thu, 28 Jan 2016 14:33:05 -0500
Message-ID: <CAGoCfiwaFEWhCD9Bf61CAUiKJnFu3WKd=X2-QFBH1yERXuFRpQ@mail.gmail.com>
Subject: Re: [PATCH 17/31] media: au0828 video change to use v4l_enable_media_tuner()
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, tiwai@suse.com,
	Clemens Ladisch <clemens@ladisch.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	javier@osg.samsung.com, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Arnd Bergmann <arnd@arndb.de>, dan.carpenter@oracle.com,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Antti Palosaari <crope@iki.fi>, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	SF Markus Elfring <elfring@users.sourceforge.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	labbott@fedoraproject.org,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	ricard.wanderlof@axis.com, Julian Scheel <julian@jusst.de>,
	takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com,
	daniel@zonque.org, Jurgen Kramer <gtmkramer@xs4all.nl>,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-api@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah, Mauro,

>> Did you test the code when the input is not a tuner, but, instead,
>> Composite or S-Video connector, as shown at:
>>       https://mchehab.fedorapeople.org/mc-next-gen/au0828.png
>
> I am not sure if I did or not. I can double check this case.
> Do you have concerns that this won't work?

I'm not sure how you expect the MC framework to be handling this case,
but I can tell you that the hardware will *not* support simultaneous
streaming of the DVB feed at the same time as the analog feed, even if
you're using the composite/s-video input and not actually using the
xc5000 tuner in analog mode.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

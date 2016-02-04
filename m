Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45797 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbcBDVfd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2016 16:35:33 -0500
Subject: Re: [PATCH] [media] vb2-core: call threadio->fnc() if
 !VB2_BUF_STATE_ERROR
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <788b10195174037a7d3d3011c9f2a4a7170bc0a8.1454538542.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Junghak Sung <jh1009.sung@samsung.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <56B3C40C.50807@gentoo.org>
Date: Thu, 4 Feb 2016 22:35:08 +0100
MIME-Version: 1.0
In-Reply-To: <788b10195174037a7d3d3011c9f2a4a7170bc0a8.1454538542.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.02.2016 um 23:30 schrieb Mauro Carvalho Chehab:
> changeset 70433a152f0 ("media: videobuf2: Refactor vb2_fileio_data
> and vb2_thread") broke videobuf2-dvb.
> 
> The root cause is that, instead of calling threadio->fnc() for
> all types of events except for VB2_BUF_STATE_ERROR, it was calling
> it only for VB2_BUF_STATE_DONE.
> 
> With that, the DVB thread were never called.
> 
With this patch applied, I can confirm that receiving of dvb data works
again.

Regards
Matthias


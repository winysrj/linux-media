Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4023 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZHLMrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 08:47:11 -0400
Message-ID: <e9ccb1ebe7481e003e25ba352096b8bf.squirrel@webmail.xs4all.nl>
In-Reply-To: <alpine.LFD.2.00.0908120737580.20085@localhost>
References: <alpine.LFD.2.00.0908120737580.20085@localhost>
Date: Wed, 12 Aug 2009 14:47:08 +0200
Subject: Re: unused RADIO_TYPHOON_PROC_FS?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>   my latest scan of the source tree shows the definition of the
> Kconfig variable RADIO_TYPHOON_PROC_FS, but no usage of it anywhere.
> just an observation.

Thanks, it can indeed be removed.

I'll see if I can queue this to our repository.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG


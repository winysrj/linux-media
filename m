Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([67.18.53.17]:49356 "EHLO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934660Ab3E1Q3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 12:29:49 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway08.websitewelcome.com (Postfix) with ESMTP id 488D950B625FF
	for <linux-media@vger.kernel.org>; Tue, 28 May 2013 11:05:53 -0500 (CDT)
Message-ID: <51A4D5E0.9010804@sensoray.com>
Date: Tue, 28 May 2013 09:05:52 -0700
From: Pete Eberlein <pete@sensoray.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Ben Hutchings <ben@decadent.org.uk>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] go7007 firmware updates
References: <201305231025.31812.hverkuil@xs4all.nl> <1369671872.3469.383.camel@deadeye.wl.decadent.org.uk> <201305272156.18975.hverkuil@xs4all.nl>
In-Reply-To: <201305272156.18975.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/27/2013 12:56 PM, Hans Verkuil wrote:
> I can revert the rename action,  but I would rather not do it. I
 > believe there are good reasons for doing this, especially since the
 > current situation is effectively broken anyway due to the missing
 > firmware files.
 >
 > If you really don't want to rename the two S2250 files, then I'll
 > make a patch reverting those to the original filename.
 >
 > Pete, if you have an opinion regarding this, please let us know.
 > After all, it concerns a Sensoray device.

I am okay with the change of the firmware filenames.  I've changed them 
myself several times in the past before it got into kernel staging.

> Regards,
 >
 > Hans
 >

Regards,
Pete

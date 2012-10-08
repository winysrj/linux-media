Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39386 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2JHHR1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 03:17:27 -0400
Message-ID: <50727DF0.50703@iki.fi>
Date: Mon, 08 Oct 2012 10:17:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC v3] dvb: LNA implementation changes
References: <1349252936-2728-1-git-send-email-crope@iki.fi> <20121007103133.5bbe9170@redhat.com>
In-Reply-To: <20121007103133.5bbe9170@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2012 04:31 PM, Mauro Carvalho Chehab wrote:

> Hmm... on a second thought, I think that the implementation there should not me that
> simple: during tuner sleep, and suspend/resume, you may need to force LNA to off, in
> order to save power and prevent device overheat.
>
> Still, as the previous code weren't doing it, I'm still applying it, but I think we
> need to properly handle such cases.

I agree that, lets add it later. I don't see it even very important - 
LNA eats reasonable less power, only few mA. There is much bigger 
power-management issues currently about everywhere.

regards
Antti

-- 
http://palosaari.fi/

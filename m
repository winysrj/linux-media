Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45378 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2AOVrO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:47:14 -0500
Message-ID: <4F13495E.8030106@iki.fi>
Date: Sun, 15 Jan 2012 23:47:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F0CAF53.3090802@iki.fi> <4F0CB512.7010501@redhat.com> <4F131CD8.2060602@iki.fi> <4F13312B.8060005@iki.fi> <4F13404D.2020001@redhat.com>
In-Reply-To: <4F13404D.2020001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2012 11:08 PM, Mauro Carvalho Chehab wrote:
> There was a bug at the error code handling on dvb-fe-tool: basically, if it can't open
> a device, it were using a NULL pointer. It was likely fixed by this commit:
>
> http://git.linuxtv.org/v4l-utils.git/commit/1f669eed5433d17df4d8fb1fa43d2886f99d3991

That bug was fixed as I tested.

But could you tell why dvb-fe-tool --set-delsys=DVBC/ANNEX_A calls 
get_frontent() ?

That will cause this kind of calls in demod driver:
init()
get_frontend()
get_frontend()
sleep()

My guess is that it resolves current delivery system. But as demod is 
usually sleeping (not tuned) at that phase it does not know frontend 
settings asked, like modulation etc. In case of cxd2820r those are 
available after set_frontend() call. I think I will add check and return 
-EINVAL in that case.

regards
Antti
-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45960 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab3GBEVK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 00:21:10 -0400
From: Libin Yang <lbyang@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"albert.v.wang@gmail.com" <albert.v.wang@gmail.com>,
	Albert Wang <twang13@marvell.com>
Date: Mon, 1 Jul 2013 21:21:05 -0700
Subject: RE: [PATCH v2 1/7] marvell-ccic: add MIPI support for marvell-ccic
 driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF44D6878470@SC-VEXCH4.marvell.com>
References: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
	<1372735868-15880-2-git-send-email-lbyang@marvell.com>
 <20130701220829.73c9c202@lwn.net>
In-Reply-To: <20130701220829.73c9c202@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

Sorry, it's my silly fault. I will update it.

Regards,
Libin 

>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Tuesday, July 02, 2013 12:08 PM
>To: Libin Yang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; albert.v.wang@gmail.com;
>Albert Wang
>Subject: Re: [PATCH v2 1/7] marvell-ccic: add MIPI support for marvell-ccic driver
>
>For future reference, it's nice to summarize the changes made since the
>previous posting.
>
>In a really quick scan, I immediately stumbled across this:
>
>> @@ -1816,7 +1884,9 @@ int mccic_resume(struct mcam_camera *cam)
>>
>>  	mutex_lock(&cam->s_mutex);
>>  	if (cam->users > 0) {
>> -		mcam_ctlr_power_up(cam);
>> +		ret = mcam_ctlr_power_up(cam);
>> +		if (ret)
>> +			return ret;
>
>You do see the problem here, right?  Can I ask you to please audit *all*
>of your changes to be sure they don't leak locks?  This isn't the sort of
>problem that should need to be pointed out twice.
>
>Don't get me wrong, I very much appreciate the effort you have put into
>getting these patches ready for merging, and things are quite close.  But
>it's important to get details like this right.
>
>Thanks,
>
>jon

Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:52182 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab3CFPNg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 10:13:36 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 07:12:30 -0800
Subject: RE: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree
 support for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA93@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-3-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051047120.25837@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D9D8DAA88@SC-VEXCH1.marvell.com>
 <Pine.LNX.4.64.1303061557350.7010@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303061557350.7010@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 06 March, 2013 23:00
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree support for
>marvell-ccic driver
>
>Hi Albert
>
>On Wed, 6 Mar 2013, Albert Wang wrote:
>
>> Hi, Guennadi
>>
>>
>> >-----Original Message-----
>> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>> >Sent: Tuesday, 05 March, 2013 17:51
>> >To: Albert Wang
>> >Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>> >Subject: Re: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree support
>for
>> >marvell-ccic driver
>
>[snip]
>
>> >> @@ -331,6 +374,10 @@ static int mmpcam_probe(struct platform_device *pdev)
>> >>  		ret = -ENODEV;
>> >>  		goto out_unmap1;
>> >>  	}
>> >> +
>> >> +	ret = mcam_init_clk(mcam, pdata);
>> >> +	if (ret)
>> >> +		goto out_unmap2;
>> >
>> >Now, I'm confused again: doesn't this mean, that all existing users of
>> >this driver will fail?
>> >
>> Sorry, I don't understand what's your concern?
>
>I mean - wouldn't the above function fail for all existing users, because
>they don't provide the clocks, that you're requesting here?
>
OK, I see. We will update it.


>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/


Thanks
Albert Wang
86-21-61092656

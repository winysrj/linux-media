Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48880 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab2C2Sxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 14:53:45 -0400
Received: by bkcik5 with SMTP id ik5so2306462bkc.19
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2012 11:53:44 -0700 (PDT)
Message-ID: <4F74AFB4.800@gmail.com>
Date: Thu, 29 Mar 2012 20:53:40 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	t.stanislaws@samsung.com
Subject: Re: [Q] What sensor does s5K6aa driver support?
References: <CACKLOr1h58fFATxrPD+ZCE86Cd9P-LaBa-0utxT766gqsqaKZA@mail.gmail.com>
In-Reply-To: <CACKLOr1h58fFATxrPD+ZCE86Cd9P-LaBa-0utxT766gqsqaKZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

On 03/26/2012 11:55 AM, javier Martin wrote:
> Hi,
> the following driver claims to support S5K6AAFX Samsung sensor:
> http://lxr.linux.no/#linux+v3.3/drivers/media/video/s5k6aa.c
> 
> However, we've been informed that this reference is marked as EOL. Has
> anyone tested this driver with anothe sensor compatible with S5K6AAFX
> that can be used as a replacement?

It's rather unlikely to get this driver working with other sensors
without any modifications. Although the required changes might not be 
significant, still it would probably make more sense to write a new driver 
for another sensor.

I'm not sure who provided you with the information this sensor is being
discontinued, but wasn't it suggested to you what other similar sensors 
are available and can be used instead ?


--
Regards,
Sylwester Nawrocki

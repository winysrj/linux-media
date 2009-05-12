Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:40728 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZELSbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 14:31:16 -0400
Received: by gxk10 with SMTP id 10so268313gxk.13
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 11:31:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <155082.98228.qm@web32102.mail.mud.yahoo.com>
References: <155119.7889.qm@web32103.mail.mud.yahoo.com>
	 <Pine.LNX.4.64.0905071750050.9460@axis700.grange>
	 <951499.48393.qm@web32102.mail.mud.yahoo.com>
	 <Pine.LNX.4.64.0905120908220.5087@axis700.grange>
	 <155082.98228.qm@web32102.mail.mud.yahoo.com>
Date: Tue, 12 May 2009 11:31:14 -0700
Message-ID: <e9c3a7c20905121131q3c007e9p56c7b754ecd1466f@mail.gmail.com>
Subject: Re: [PATCH] dma: fix ipu_idmac.c to not discard the last queued
	buffer
From: Dan Williams <dan.j.williams@intel.com>
To: Agustin <gatoguan-os@yahoo.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 5:14 AM, Agustin <gatoguan-os@yahoo.com> wrote:
>
> On Tue, 12 May 2009, Guennadi Liakhovetski wrote:
>
>>
>> This also fixes the case of a single queued buffer, for example, when taking a
>> single frame snapshot with the mx3_camera driver.
>>
>> Reported-by: Agustin
>> Signed-off-by: Guennadi Liakhovetski
>
> Signed-off-by: Agustin Ferrin Pozuelo

Applied.

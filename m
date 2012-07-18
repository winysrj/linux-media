Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60054 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2GRJBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 05:01:06 -0400
Received: by wgbdr13 with SMTP id dr13so1176225wgb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 02:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342600546.2542.101.camel@pizza.hi.pengutronix.de>
References: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
	<1342459273.2535.665.camel@pizza.hi.pengutronix.de>
	<CACKLOr3rOPgwMCRdj3ARR+0655Qp=BfEXq0TsB7TU-hO4NSsqg@mail.gmail.com>
	<1342600546.2542.101.camel@pizza.hi.pengutronix.de>
Date: Wed, 18 Jul 2012 11:01:04 +0200
Message-ID: <CACKLOr1i-iByVtST6sqXqmHHzhJ1mgUdBWjp-jFsYPX-bnAMxQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 July 2012 10:35, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Javier,
>
> Am Mittwoch, den 18.07.2012, 09:12 +0200 schrieb javier Martin:
> [...]
>> > I see there is a comment about the expected register setting not working
>> > for CODA_REG_BIT_STREAM_CTRL in start_streaming(). Could this be
>> > related?
>>
>> I don't think so. This means that the following line:
>>
>> coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
>>
>> should be:
>>
>> coda_write(dev, (CODADX6_STREAM_BUF_PIC_RESET |
>> CODADX6_STREAM_BUF_PIC_FLUSH), CODA_REG_BIT_STREAM_CTRL);
>>
>> But the latter does not work.
>
> Looks to me like (3 << 3) == (CODA7_STREAM_BUF_PIC_RESET |
> CODA7_STREAM_BUF_PIC_FLUSH) could be the explanation.

You mean "!=", don't you?

> Maybe the documentation about CODADX6_STREAM_BUF_PIC_RESET |
> CODADX6_STREAM_BUF_PIC_FLUSH was outdated?

Maybe some of these two defines is wrong, I don't know exactly. Maybe
when support for other coda versions is added we'll find out. To
clarify my magic value (3 << 3) I decided to add a comment explaining
that what I am doing is a reset and flush.

>> > Also, I've missed two problems with platform device removal and module
>> > autoloading before, see below.
>>
>> Fine.
> [...]
>> I will send a new v4 with the 'platform' and 'bytesused' issues fixed.
>> Regarding your i.MX53 problems I suppose they should be addressed
>> conditionally in a patch on top of this one where i.MX53 support is
>> added too.
>> What do you think?
>
> Agreed. After fixing the issues in vidioc_try_fmt, MODULE_DEVICE_TABLE,
> and coda_remove, feel free to add a
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>

OK I expect to send v4 during the morning.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

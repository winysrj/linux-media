Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3973 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZDMLK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 07:10:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: tuner-core i2c address range check: time to remove them?
Date: Mon, 13 Apr 2009 13:10:18 +0200
Cc: Mike Krufky <mkrufky@linuxtv.org>
References: <200903292253.01684.hverkuil@xs4all.nl>
In-Reply-To: <200903292253.01684.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131310.18758.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 29 March 2009 22:53:01 Hans Verkuil wrote:
> Hi all,
>
> The tuner-core.c source contains this warning since 2.6.24:
>
> tuner_warn("Support for tuners in i2c address range 0x64 thru 0x6f\n");
> tuner_warn("will soon be dropped. This message indicates that your\n");
> tuner_warn("hardware has a %s tuner at i2c address 0x%02x.\n",
>                    t->name, t->i2c->addr);
> tuner_warn("To ensure continued support for your device, please\n");
> tuner_warn("send a copy of this message, along with full dmesg\n");
> tuner_warn("output to v4l-dvb-maintainer@linuxtv.org\n");
> tuner_warn("Please use subject line: \"obsolete tuner i2c address.\"\n");
> tuner_warn("driver: %s, addr: 0x%02x, type: %d (%s)\n",
>                    t->i2c->adapter->name, t->i2c->addr, t->type,
> t->name);
>
> Isn't it time to remove these i2c addresses? I don't believe we ever had
> a real tuner at such an address.
>
> With the ongoing v4l2_subdev conversion I need to do a bit of cleanup in
> tuner-core.c as well, so it would be a good time for me to combine it
> (and it gets rid of an ugly cx88 hack in tuner-core.c as well).
>
> Regards,
>
> 	Hans

Mike, please let me know if I can remove this!

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2JAMBE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 08:01:04 -0400
Message-ID: <506985F2.1020604@redhat.com>
Date: Mon, 01 Oct 2012 09:00:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Antoine Reversat <a.reversat@gmail.com>
Subject: Re: [PATCH v2] omap3isp: Use monotonic timestamps for statistics
 buffers
References: <1347659868-17398-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120927135233.3acd00a5@redhat.com> <5064ADCE.3000708@iki.fi>
In-Reply-To: <5064ADCE.3000708@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-09-2012 16:49, Sakari Ailus escreveu:
> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
>> Em Fri, 14 Sep 2012 23:57:48 +0200
>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
...
>>>   struct omap3isp_stat_data {
>>> -    struct timeval ts;
>>> +    struct timespec ts;
>>
>> NACK. That breaks userspace API, as this structure is part of an ioctl.
>>
>> It is too late to touch here. Please keep timeval. It is ok to fill it with
>> a mononotic time, but replacing it is an API breakage.
> 
> I beg to present a differing opinion.
> 
> The timestamp that has been taken from a realtime clock has NOT been useful to begin with in this context: the OMAP3ISP driver has used monotonic time on video buffers since the very beginning of its existence in mainline kernel. As no-one has complained about this --- except Antoine very recently --- I'm pretty certain we wouldn't be breaking any application by changing this. The statistics timestamp is only useful when it's comparable to other timestamps (from video buffers and events), which this patch achieves.

Technically, the only gain here would be to improve the precision from microsseconds
to nanosseconds.

Breaking the API due to that could only be justified if you have really fast
sensors that would be able to take more than one picture at the 1 microssecond
period of time.

Regards,
Mauro




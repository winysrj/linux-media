Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3550 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaCLMWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 08:22:33 -0400
Message-ID: <53205155.7030003@xs4all.nl>
Date: Wed, 12 Mar 2014 13:21:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 14/35] v4l2-ctrls: prepare for matrix support.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-15-git-send-email-hverkuil@xs4all.nl> <20140312074221.73ee30b1@samsung.com>
In-Reply-To: <20140312074221.73ee30b1@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/14 11:42, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Feb 2014 10:57:29 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add core support for matrices.
> 
> Again, this patch has negative values for array index.
> 
> I'll stop analyzing here, as it is hard to keep the mind in a
> sane state seeing those crazy things ;)

Rather than getting bogged down in these details can you please give
your opinion on the public API aspects. There is no point for me to
spend time on this and then get it NACKed because you don't like the
API itself and want something completely different.

Internal things I can change, but I'm not going to spend a second on
that unless I know the concept stands. Otherwise it is wasted time.

This is something we need to improve on with regards to our
processes: when it comes to API enhancements you really need to be
involved earlier or it's going to be a huge waste of everyones time
it is gets NACked. Not to mention demotivating and frustrating for
all concerned.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35376 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaCLNAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 09:00:48 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B00ILOQTBNG10@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 09:00:47 -0400 (EDT)
Date: Wed, 12 Mar 2014 10:00:41 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 14/35] v4l2-ctrls: prepare for matrix support.
Message-id: <20140312100041.513e0a0e@samsung.com>
In-reply-to: <53205155.7030003@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-15-git-send-email-hverkuil@xs4all.nl>
 <20140312074221.73ee30b1@samsung.com> <53205155.7030003@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 12 Mar 2014 13:21:41 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/12/14 11:42, Mauro Carvalho Chehab wrote:
> > Em Mon, 17 Feb 2014 10:57:29 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add core support for matrices.
> > 
> > Again, this patch has negative values for array index.
> > 
> > I'll stop analyzing here, as it is hard to keep the mind in a
> > sane state seeing those crazy things ;)
> 
> Rather than getting bogged down in these details can you please give
> your opinion on the public API aspects. There is no point for me to
> spend time on this and then get it NACKed because you don't like the
> API itself and want something completely different.
> 
> Internal things I can change, but I'm not going to spend a second on
> that unless I know the concept stands. Otherwise it is wasted time.

Ok, what patches after 16/35 contains the API bits?

The changes I saw so far seem ok, with the adjustments I pointed.

> This is something we need to improve on with regards to our
> processes: when it comes to API enhancements you really need to be
> involved earlier or it's going to be a huge waste of everyones time
> it is gets NACked. Not to mention demotivating and frustrating for
> all concerned.

As I commented before: those complex API changes should ideally
be discussed during our mini-summits, as it allows us to better
understand the hole proposal and the taken approach.

-- 

Regards,
Mauro

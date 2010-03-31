Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26903 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0CaHEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 03:04:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L0400182WZU9V30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 08:04:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L040088OWZU5U@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 08:04:42 +0100 (BST)
Date: Wed, 31 Mar 2010 09:02:44 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework
 for videobuf.
In-reply-to: <1269863821.3952.8.camel@palomino.walls.org>
To: 'Andy Walls' <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, hvaibhav@ti.com
Message-id: <003701cad0a0$29b4a5d0$7d1df170$%osciak@samsung.com>
Content-language: pl
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
 <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
 <1269863821.3952.8.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Andy Walls [mailto:awalls@md.metrocast.net] wrote:


>I didn't do a full review (I have no time lately), but I noticed this:
>
>
>> +static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>> +{
>> +	struct v4l2_m2m_dev *m2m_dev;
>[...]
>> +	v4l2_m2m_try_run(m2m_dev);
>> +}
>
>[...]
>
>> +void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
>> +			 struct v4l2_m2m_ctx *m2m_ctx)
>> +{
>[...]
>> +	  v4l2_m2m_try_schedule(m2m_ctx);
>> +	v4l2_m2m_try_run(m2m_dev);
>> +}
>
>I assume it is not bad, but was it your intention to have an addtitonal
>call to v4l2_m2m_try_run() ?


Thanks for noticing that, but yes, this is intentional. Simplifies the code
a bit and will work properly.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center






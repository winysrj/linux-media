Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4639 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0CQO02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:26:28 -0400
Message-ID: <1b349bbb89725540c70175130caf9ae3.squirrel@webmail.xs4all.nl>
In-Reply-To: <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com>
    <1268831061-307-2-git-send-email-p.osciak@samsung.com>
    <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
Date: Wed, 17 Mar 2010 15:26:21 +0100
Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: "Pawel Osciak" <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi,
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Pawel Osciak
>> Sent: Wednesday, March 17, 2010 8:04 AM
>> To: linux-media@vger.kernel.org
>> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
>> kyungmin.park@samsung.com
>> Subject: [PATCH v2] v4l: videobuf: code cleanup.
>>
>> Make videobuf pass checkpatch; minor code cleanups.
>
> I thought this kind patches were frowned upon..
>
> http://www.mjmwired.net/kernel/Documentation/development-process/4.Coding#41
>
> But maybe it's acceptable in this case... I'm not an expert on community
> policies :)

It is true that you shouldn't do this 'just to clean up code'. But in this
case we want to do a lot of work on the videobuf framework, and it helps a
lot if it is first brought up to date with the coding standards.

It's just step one in a much longer process :-)

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


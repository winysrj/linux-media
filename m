Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36789 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbbEOMCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:02:43 -0400
Received: by lagv1 with SMTP id v1so115901825lag.3
        for <linux-media@vger.kernel.org>; Fri, 15 May 2015 05:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431685897-11153-2-git-send-email-hverkuil@xs4all.nl>
References: <1431685897-11153-1-git-send-email-hverkuil@xs4all.nl> <1431685897-11153-2-git-send-email-hverkuil@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 15 May 2015 14:02:21 +0200
Message-ID: <CAPybu_1G7kD-O_xNE=QcqVjftDFsPVmNh-uhnHazTPgnSv3FVg@mail.gmail.com>
Subject: Re: [PATCH 2/2] DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

My bad sorry, I should have send this patch myself.

Shouldn't it be? :

00 high
00 low
01 high
01 low
02 high
02 low
03 high
03 low

10 high
10 low
11 high
11 low
12 high
12 low
13 high
13 low

20 high
20 low
21 high
21 low
22 high
22 low
23 high
23 low

30 high
30 low
31 high
31 low
32 high
32 low
33 high
33 low


Thanks


ps: I am sending the patch for libv4lconvert right away, and the patch
for qv4l during next week (I havent dont gl before)

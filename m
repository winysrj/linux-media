Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3757 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIDNOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 09:14:23 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s84DEJlN097673
	for <linux-media@vger.kernel.org>; Thu, 4 Sep 2014 15:14:21 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 6757E2A075A
	for <linux-media@vger.kernel.org>; Thu,  4 Sep 2014 15:14:13 +0200 (CEST)
Message-ID: <54086581.8010809@xs4all.nl>
Date: Thu, 04 Sep 2014 15:13:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANN] Created a patch to teach valgrind about V4L2 and the media
 API
References: <53DF488A.4080307@xs4all.nl>
In-Reply-To: <53DF488A.4080307@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/14 10:47, Hans Verkuil wrote:
> See this bugreport for valgrind with the attached patch:
> 
> https://bugs.kde.org/show_bug.cgi?id=338023

A quick follow-up: this patch has been committed in the valgrind repo,
so I assume it will appear in the next valgrind release.

Regards,

	Hans

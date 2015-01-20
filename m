Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39043 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbbATHfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 02:35:34 -0500
Message-ID: <54BE052F.6060205@xs4all.nl>
Date: Tue, 20 Jan 2015 08:35:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media_build] commit 26052b8e1 (SMIAPP needs kernel 3.20 or up.)
References: <54BD3C56.4070600@xs4all.nl> <54BD55C3.6080201@gmail.com>
In-Reply-To: <54BD55C3.6080201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2015 08:06 PM, Tycho Lürsen wrote:
> 
> Hi Hans,
> 
> tested this update in media_build against a Debian 3.16 kernel.
> It still tries to build SMIAPP. So sadly it still gives the same error.

Try again. I missed a duplicate VIDEO_SMIAPP entry in versions.txt that is
now deleted. I just tried it and it now builds fine for me.

Regards,

	Hans

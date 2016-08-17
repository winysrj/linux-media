Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55395 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbcHQWIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 18:08:44 -0400
Subject: Re: [PATCH v4] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, jgebben@codeaurora.org,
	mchehab@osg.samsung.com
References: <1464706979-32340-1-git-send-email-helen.koike@collabora.co.uk>
 <5aae6086-6ba3-c278-ec48-043b17b4aa33@xs4all.nl>
Cc: Helen Fornazier <helen.fornazier@gmail.com>
From: Helen Koike <helen.koike@collabora.co.uk>
Message-ID: <5f356876-2d91-cebb-a3f6-47ec21753c62@collabora.co.uk>
Date: Wed, 17 Aug 2016 19:08:08 -0300
MIME-Version: 1.0
In-Reply-To: <5aae6086-6ba3-c278-ec48-043b17b4aa33@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On 01-07-2016 09:39, Hans Verkuil wrote:
> Hi Helen,
>
> Better late than never, but I finally have time for a review, mostly with a eye for V4L2 issues.

Thank you for your review, I'll incorporate your suggestions in v5.
I am also preparing a patch series that integrates the tpg and have much 
more functionality, I want to add the optimization where I analyze the 
pipe and generate the final image directly from the video capture node 
instead of processing all the images in each processing unit. I hope 
that it will be useful.

Helen

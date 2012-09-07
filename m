Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33710 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2IGUEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:04:31 -0400
Received: by eaac11 with SMTP id c11so1072953eaa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:04:29 -0700 (PDT)
Message-ID: <504A534B.80702@gmail.com>
Date: Fri, 07 Sep 2012 22:04:27 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 08/28] v4l2: remove experimental tag from a
 number of old drivers.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <0cbef0a949709d1c824b850f5bf59225d224059e.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <0cbef0a949709d1c824b850f5bf59225d224059e.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> A number of old drivers still had the experimental tag. Time to remove it.
>
> It concerns the following drivers:
>
> VIDEO_TLV320AIC23B
> USB_STKWEBCAM
> VIDEO_CX18
> VIDEO_CX18_ALSA
> VIDEO_ZORAN_AVS6EYES
> DVB_USB_AF9005
> MEDIA_TUNER_TEA5761
> VIDEO_NOON010PC30
>
> This decision was taken during the 2012 Media Workshop.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

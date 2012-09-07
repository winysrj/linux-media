Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2IGULP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:11:15 -0400
Received: by eaac11 with SMTP id c11so1075410eaa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:11:14 -0700 (PDT)
Message-ID: <504A54E0.5030708@gmail.com>
Date: Fri, 07 Sep 2012 22:11:12 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 12/28] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <86a39343d33f0f75079407d8b36202a1de4c58de.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <86a39343d33f0f75079407d8b36202a1de4c58de.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Add a new flag that tells userspace that the monotonic clock is used
> for timestamps and update the documentation accordingly.
>
> We decided on this new flag during the 2012 Media Workshop.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

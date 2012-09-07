Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62271 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2IGUIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 16:08:06 -0400
Received: by eaac11 with SMTP id c11so1074289eaa.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 13:08:05 -0700 (PDT)
Message-ID: <504A5422.80202@gmail.com>
Date: Fri, 07 Sep 2012 22:08:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 11/28] DocBook: fix awkward language and fix
 the documented return value.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <9190d2916210424b0f49a0ea678698ff9ea5dcaf.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <9190d2916210424b0f49a0ea678698ff9ea5dcaf.1347023744.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2012 03:29 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> The Video Standard section contains some awkward language. It also wasn't
> updated when the error code for unimplemented ioctls changed from EINVAL
> to ENOTTY.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

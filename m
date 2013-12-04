Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42469 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3LDXFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 18:05:14 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so14025301wgh.5
        for <linux-media@vger.kernel.org>; Wed, 04 Dec 2013 15:05:12 -0800 (PST)
Message-ID: <529FB526.3040104@gmail.com>
Date: Thu, 05 Dec 2013 00:05:10 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/3] V4L2 OF fixes
References: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/04/2013 08:29 PM, Laurent Pinchart wrote:
> Hello,
>
> Here are three small fixes for the V4L2 OF parsing code. The patches should be
> self-explanatory.
>
> Laurent Pinchart (3):
>    v4l: of: Return an int in v4l2_of_parse_endpoint()
>    v4l: of: Remove struct v4l2_of_endpoint remote field
>    v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port()

Thank you for the fixes, all three patches

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f66.google.com ([74.125.83.66]:53881 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2F3UVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 16:21:25 -0400
Received: by eeke50 with SMTP id e50so371515eek.1
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 13:21:23 -0700 (PDT)
Message-ID: <4FEF5FC0.3050303@gmail.com>
Date: Sat, 30 Jun 2012 22:21:20 +0200
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 2/8] v4l: Remove "_ACTUAL" from subdev selection API target
 definition names
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk> <1341075839-18586-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1341075839-18586-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/30/2012 07:03 PM, Sakari Ailus wrote:
> The string "_ACTUAL" does not say anything more about the target names. Drop
> it. V4L2 selection API was changed by "V4L: Remove "_ACTIVE" from the
> selection target name definitions" by Sylwester Nawrocki. This patch does
> the same for the V4L2 subdev API.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester

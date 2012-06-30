Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f66.google.com ([74.125.83.66]:50429 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2F3U3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 16:29:35 -0400
Received: by eeke50 with SMTP id e50so371854eek.1
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 13:29:34 -0700 (PDT)
Message-ID: <4FEF61AB.4000906@gmail.com>
Date: Sat, 30 Jun 2012 22:29:31 +0200
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 8/8] v4l: Correct conflicting V4L2 subdev selection API
 documentation
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk> <1341075839-18586-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1341075839-18586-8-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/30/2012 07:03 PM, Sakari Ailus wrote:
> The API reference documents that the KEEP_CONFIG flag tells the
> configuration should not be propagated by the driver whereas the interface
> documentation (dev-subdev.xml) prohibited any changes to the rest of the
> pipeline. Resolve the conflict by changing the API reference to disallow
> changes.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>

Thanks for the patch. It seems much clearer to have the drivers
not propagating the configuration whenever KEEP_CONFIG is set, rather
than relying on not clearly defined additional conditions.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

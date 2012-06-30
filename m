Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f66.google.com ([74.125.83.66]:51278 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2F3Ugl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 16:36:41 -0400
Received: by eeke50 with SMTP id e50so372147eek.1
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 13:36:39 -0700 (PDT)
Message-ID: <4FEF6046.9090604@gmail.com>
Date: Sat, 30 Jun 2012 22:23:34 +0200
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 5/8] v4l: Unify selection flags
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk> <1341075839-18586-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1341075839-18586-5-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/30/2012 07:03 PM, Sakari Ailus wrote:
> Unify flags on the selection interfaces on V4L2 and V4L2 subdev. Flags are
> very similar to targets in this case: there are more similarities than
> differences between the two interfaces.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>

Thanks for the patch.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


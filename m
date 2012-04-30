Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33539 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2D3Iez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 04:34:55 -0400
Received: by iadi9 with SMTP id i9so3823973iad.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 01:34:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 10:34:54 +0200
Message-ID: <CAGGh5h0nFxmX8rP-Sxu3CqCccX=dzpiqHy3VLvne2X3CwgvXHA@mail.gmail.com>
Subject: subdev_pad_ops vs video_ops
From: jean-philippe francois <jp.francois@cynove.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

subdev_pad_ops and video_ops both contains operation related
to format, crop and bus format.

When should one or the other be used ?
For example mt9p031 implement everything using pad_ops, but other drivers
use video_ops functions.

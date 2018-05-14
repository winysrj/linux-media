Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47567 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752594AbeENMLv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 08:11:51 -0400
Subject: Re: [RFC PATCH 1/6] pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hansverk@cisco.com>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
 <20180514115602.9791-2-hverkuil@xs4all.nl>
Message-ID: <dd29b1de-0949-75e1-ade8-9371bca8fc59@xs4all.nl>
Date: Mon, 14 May 2018 14:11:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180514115602.9791-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2018 01:55 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> This driver is the only V4L driver that does not set unlocked_ioctl
> to video_ioctl2.
> 
> The only thing that pvr2_v4l2_ioctl does besides calling video_ioctl2
> is calling pvr2_hdw_commit_ctl(). Add pvr2_hdw_commit_ctl() calls to
> the various ioctls that need this, and we can replace pvr2_v4l2_ioctl
> by video_ioctl2.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>

Tested-by: Hans Verkuil <hansverk@cisco.com>

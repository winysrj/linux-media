Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39803 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753580AbeFJSfT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 14:35:19 -0400
Received: by mail-lf0-f67.google.com with SMTP id t134-v6so27255762lff.6
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 11:35:18 -0700 (PDT)
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Subject: Re: [PATCH] media: s3c-camif: ignore -ENOIOCTLCMD from
 v4l2_subdev_call for s_power
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1528645321-19020-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <6adf6a84-b542-dc88-2c6f-d70915c31aa0@gmail.com>
Date: Sun, 10 Jun 2018 20:35:15 +0200
MIME-Version: 1.0
In-Reply-To: <1528645321-19020-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2018 05:42 PM, Akinobu Mita wrote:
> When the subdevice doesn't provide s_power core ops callback, the
> v4l2_subdev_call for s_power returns -ENOIOCTLCMD.  If the subdevice
> doesn't have the special handling for its power saving mode, the s_power
> isn't required.  So -ENOIOCTLCMD from the v4l2_subdev_call should be
> ignored.

> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>

Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

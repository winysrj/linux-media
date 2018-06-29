Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39884 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeF2SMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:12:55 -0400
Message-ID: <fc2940abb7b16e5ba0211d34320d847d7db27ca8.camel@collabora.com>
Subject: Re: [PATCH v4 00/17] v4l2 core: push ioctl lock down to ioctl
 handler
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date: Fri, 29 Jun 2018 15:12:49 -0300
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-15 at 16:07 -0300, Ezequiel Garcia wrote:
> Fourth spin of the series posted by Hans:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg131363.ht
> ml
> 
> There aren't any changes from v3, aside from rebasing
> and re-ordering the patches as requested by Hans.
> 
> See v3 cover letter for more details.
> 
> Series was tested with tw686x, gspca sonixj and UVC devices.
> Build tested with the 0-day kbuild test robot.
> 
> 

AFAIK, nothing is preventing this series.

Hans, is there any other feedback?

Thanks,
Ezequiel

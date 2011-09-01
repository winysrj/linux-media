Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4932 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab1IAPFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:05:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "LBM" <lbm9527@qq.com>
Subject: Re: migrate soc-camera  to the new V4L2 control framework
Date: Thu, 1 Sep 2011 17:03:35 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <tencent_0C380C8745A3DBBC44C922E8@qq.com>
In-Reply-To: <tencent_0C380C8745A3DBBC44C922E8@qq.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011703.35799.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, September 01, 2011 09:47:19 LBM wrote:
> Hello Hans Verkuil
>    
>         Thank you very much for your work for us about "migrate soc-camera  to the new V4L2 control framework"!
>         I can't find the full code about the "migrate soc-camera  to the new V4L2 control framework".I just see something on some "PATCH".so, if you can email the full codes to me ?
>   
>                                      THANKS 
>                                          LEE

The code is available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/soc1

It's not quite ready yet: I found some issues with my patches for mt9m001,
mt9m111 and mt9t031. I hope to address those in a few days. But the remainder
of the patches is fine I believe. Unfortunately I am unable to test them since I have
temporarily no access to a soc-camera platform.

Regards,

	Hans

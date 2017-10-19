Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44530 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751020AbdJSHBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 03:01:20 -0400
Subject: Re: [PATCH 0/2] [media] rc/keymaps: add support for two RCs of
 hisilicon boards.
To: Jiancheng Xue <xuejiancheng@hisilicon.com>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, hermit.wangheming@hisilicon.com
References: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6902032-5f51-94ef-cc7e-ea3ad3ae97ff@xs4all.nl>
Date: Thu, 19 Oct 2017 09:01:14 +0200
MIME-Version: 1.0
In-Reply-To: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2017 12:54 PM, Jiancheng Xue wrote:
> Add support for two remote controllers of hisilicon boards.
> 
> Younian Wang (2):
>   [media] rc/keymaps: add support for RC of hisilicon TV demo boards
>   [media] rc/keymaps: add support for RC of hisilicon poplar board
> 
>  drivers/media/rc/keymaps/Makefile          |  2 +
>  drivers/media/rc/keymaps/rc-hisi-poplar.c  | 58 +++++++++++++++++++++++++
>  drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 70 ++++++++++++++++++++++++++++++
>  3 files changed, 130 insertions(+)
>  create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
>  create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c
> 

Did you make a mistake? You reposted these two patches, but still without any
copyright statement...

I think something went wrong here.

Regards,

	Hans

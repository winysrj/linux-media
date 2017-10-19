Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8952 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdJSHQR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 03:16:17 -0400
Subject: Re: [PATCH 0/2] [media] rc/keymaps: add support for two RCs of
 hisilicon boards.
To: Hans Verkuil <hverkuil@xs4all.nl>, <mchehab@kernel.org>
References: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
 <b6902032-5f51-94ef-cc7e-ea3ad3ae97ff@xs4all.nl>
CC: <hermit.wangheming@hisilicon.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
Message-ID: <ff9dce75-da40-ca70-ca76-8e8c6196a250@hisilicon.com>
Date: Thu, 19 Oct 2017 15:12:48 +0800
MIME-Version: 1.0
In-Reply-To: <b6902032-5f51-94ef-cc7e-ea3ad3ae97ff@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans，

On 2017/10/19 15:01, Hans Verkuil wrote:
> On 10/18/2017 12:54 PM, Jiancheng Xue wrote:
>> Add support for two remote controllers of hisilicon boards.
>>
>> Younian Wang (2):
>>   [media] rc/keymaps: add support for RC of hisilicon TV demo boards
>>   [media] rc/keymaps: add support for RC of hisilicon poplar board
>>
>>  drivers/media/rc/keymaps/Makefile          |  2 +
>>  drivers/media/rc/keymaps/rc-hisi-poplar.c  | 58 +++++++++++++++++++++++++
>>  drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 70 ++++++++++++++++++++++++++++++
>>  3 files changed, 130 insertions(+)
>>  create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
>>  create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c
>>
> 
> Did you make a mistake? You reposted these two patches, but still without any
> copyright statement...
> 
> I think something went wrong here.
> 
I haven't reposted them so far. This is still the first version. I am waiting
to see if there are any more comments. If not, I can repost them soon.

Thank you.

Regards,
Jiancheng

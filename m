Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34275 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbaLMNZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 08:25:08 -0500
Message-ID: <548C3E31.2040103@iki.fi>
Date: Sat, 13 Dec 2014 15:25:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 06/10] hd29l2: fix sparse error and warnings
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl> <1418471580-26510-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-7-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 01:52 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/dvb-frontends/hd29l2.c:29:18: warning: Variable length array is used.
> drivers/media/dvb-frontends/hd29l2.c:34:32: error: cannot size expression
> drivers/media/dvb-frontends/hd29l2.c:125:5: warning: symbol 'hd29l2_rd_reg_mask' was not declared. Should it be static?
>
> Variable length arrays are frowned upon, so replace with a fixed length and check
> that there won't be a buffer overrun.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Antti Palosaari <crope@iki.fi>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

-- 
http://palosaari.fi/

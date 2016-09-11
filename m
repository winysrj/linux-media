Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41598 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756123AbcIKRmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 13:42:25 -0400
Subject: Re: [PATCH] [media] staging/media/cec: fix coding style error
To: Richard <rgroux@sauron-mordor.net>, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <20160911160753.7tiizqan5v3dt7sx@elias.sauron-mordor.intern>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <58b5c75d-890f-1f52-2bf7-08e445da0ff3@iki.fi>
Date: Sun, 11 Sep 2016 20:42:21 +0300
MIME-Version: 1.0
In-Reply-To: <20160911160753.7tiizqan5v3dt7sx@elias.sauron-mordor.intern>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2016 07:07 PM, Richard wrote:
> Greetings Linux Kernel Developers,
>
> This is Task 10 of the Eudyptula Challenge, i fix few line over 80
> characters, hope you will accept this pacth.
>
> /Richard
>
> For the eudyptula challenge (http://eudyptula-challenge.org/).
> Simple style fix for few line over 80 characters

> -		if (!is_broadcast && !is_reply && !adap->follower_cnt &&
> +		if (is_directed && !is_reply && !adap->follower_cnt &&

!!
Antti

-- 
http://palosaari.fi/

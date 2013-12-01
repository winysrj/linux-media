Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33404 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3LAMoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Dec 2013 07:44:34 -0500
Message-ID: <529B2F30.1020509@iki.fi>
Date: Sun, 01 Dec 2013 14:44:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Adrian Minta <adrian.minta@gmail.com>, linux-media@vger.kernel.org
Subject: Re: update scan file for ro-DigiTV
References: <529AEB29.90205@gmail.com>
In-Reply-To: <529AEB29.90205@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Adrian

On 01.12.2013 09:54, Adrian Minta wrote:
> Hello,
> this is a scan file data for Romanian DigiTV
> http://www.rcs-rds.ro/personal-tv?t=cablu&pachet=digital
>
> Please add this to the list so other people can use.
>
>
> [dvb-c/ro-DigiTV]
> C 306000000 6900000 NONE QAM64

How you obtained these values?
Almost all muxes are QAM64 which is quite weird. Usually that table 
looks just like table where is QAM128 instead of QAM64, or even QAM256.

regards
Antti


> C 314000000 6900000 NONE QAM64
> C 322000000 6900000 NONE QAM64
> C 330000000 6900000 NONE QAM256
> C 338000000 6900000 NONE QAM256
> C 346000000 6900000 NONE QAM64
> C 354000000 6900000 NONE QAM64
> C 362000000 6900000 NONE QAM64
> C 370000000 6900000 NONE QAM64
> C 378000000 6900000 NONE QAM64
> C 386000000 6900000 NONE QAM64
> C 394000000 6900000 NONE QAM64
> C 402000000 6900000 NONE QAM64
> C 410000000 6900000 NONE QAM64
> C 418000000 6900000 NONE QAM64
> C 426000000 6900000 NONE QAM64
> C 434000000 6900000 NONE QAM64
> C 442000000 6900000 NONE QAM64
> C 450000000 6900000 NONE QAM64
> C 458000000 6900000 NONE QAM64
> C 466000000 6900000 NONE QAM64
> C 474000000 6900000 NONE QAM64
> C 482000000 6900000 NONE QAM64
> C 490000000 6900000 NONE QAM64
> C 498000000 6900000 NONE QAM64
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/

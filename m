Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbbJEW2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 18:28:31 -0400
Subject: Re: [PATCH 2/2] si2157: Bounds check firmware
To: Olli Salonen <olli.salonen@iki.fi>,
	Laura Abbott <labbott@fedoraproject.org>
References: <1443571810-5627-1-git-send-email-labbott@fedoraproject.org>
 <1443571810-5627-2-git-send-email-labbott@fedoraproject.org>
 <CAAZRmGxi5ZZWEBKU3s0dfkqN1kdx1nYjguorcMpRv9_cVb4A7Q@mail.gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <5612F98D.4020000@redhat.com>
Date: Mon, 5 Oct 2015 15:28:29 -0700
MIME-Version: 1.0
In-Reply-To: <CAAZRmGxi5ZZWEBKU3s0dfkqN1kdx1nYjguorcMpRv9_cVb4A7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2015 03:24 PM, Olli Salonen wrote:
> Hi Laura,
>
> While the patch itself does what it says, the return code for the
> si2157_init will be 0 even if there's a faulty firmware file. Wouldn't
> it be better to set the return code as -EINVAL like done a few lines
> earlier in the code (see below)?
>
>          if (fw->size % 17 != 0) {
>                  dev_err(&client->dev, "firmware file '%s' is invalid\n",
>                                  fw_name);
>                  ret = -EINVAL;
>                  goto err_release_firmware;
>          }
>
> Cheers,
> -olli
>


Right, I'll update with v2


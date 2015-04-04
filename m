Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:54620 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbbDDQ7X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2015 12:59:23 -0400
Message-ID: <55201867.1070602@ispras.ru>
Date: Sat, 04 Apr 2015 19:59:19 +0300
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	ldv-project@linuxtesting.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] marvell-ccic: fix memory leak on failure path
 in cafe_smbus_setup()
References: <1428106561-12623-1-git-send-email-khoroshilov@ispras.ru> <20150404153647.01d475a5@lwn.net>
In-Reply-To: <20150404153647.01d475a5@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.04.2015 16:36, Jonathan Corbet wrote:
> On Sat,  4 Apr 2015 03:16:01 +0300
> Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:
> 
>> If i2c_add_adapter() fails, adap is not deallocated.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> 
> Actually, the worse thing is that it leaves the IRQ enabled...it's good
> you moved that lines down.  Even better, of course, that the failure path
> has probably never been run during the life of this driver...:)

And hopefully it will not, but we will be ready:)

> 
> Should there be some sort of proper reported-by line for the driver
> verification project?

Till now, we used "Found by" line, but we are open to any better way.

> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>

--
Alexey

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.93]:44253
	"HELO nm4-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752577Ab1IYNUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 09:20:36 -0400
Message-ID: <4E7F2A9F.6000303@yahoo.com>
Date: Sun, 25 Sep 2011 14:20:31 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E7E43A2.3020905@yahoo.com> <4E7F2358.7090906@redhat.com>
In-Reply-To: <4E7F2358.7090906@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/09/11 13:49, Mauro Carvalho Chehab wrote:
> Ok, I've applied it, but it doesn't sound a good idea to me to do:
>
> +	mutex_unlock(&dev->lock);
>   	em28xx_init_extension(dev);
> +	mutex_lock(&dev->lock);
>
> I'll later test it with some hardware and see how well this behaves
> in practice.

No, I don't like it either. But since a kernel mutex isn't recursive, I can't 
think of a better solution at the moment.

Cheers,
Chris


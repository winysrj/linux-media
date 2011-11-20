Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1KTKCw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 05:02:52 -0500
Message-ID: <4EC8D069.1080204@redhat.com>
Date: Sun, 20 Nov 2011 11:03:21 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ezequiel <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org, elezegarcia@yahoo.com.ar,
	moinejf@free.fr
Subject: Re: [PATCH v2] [media] gspca: replaced static allocation by video_device_alloc/video_device_release
References: <20111119214621.GA2739@localhost>
In-Reply-To: <20111119214621.GA2739@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/19/2011 10:46 PM, Ezequiel wrote:
> Pushed video_device initialization into a separate function.
> Replace static allocation of struct video_device by
> video_device_alloc/video_device_release usage.
>

NACK again! There is no reason to do this, it just makes
the code more complicated without gaining anything. As already
commented by Antonio Ospite your commit message lacks the why of
this patch / the reason to do such a patch. The diffstat clearly
shows it is adding code not removing / simplifying it and it
so doing so without any good reasons!

Regards,

Hans

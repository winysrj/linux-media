Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53578 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab0BCQDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 11:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <201002021529.36727.oliver@neukum.org>
References: <4B6836DA.8030907@gmail.com> <201002021529.36727.oliver@neukum.org>
From: roel kluin <roel.kluin@gmail.com>
Date: Wed, 3 Feb 2010 17:02:49 +0100
Message-ID: <25e057c01002030802x5ae68ed9od9004565731ebd6f@mail.gmail.com>
Subject: Re: [PATCH] dvb: return -ENOMEM if kzalloc failed in
	dvb_usb_device_init()
To: Oliver Neukum <oliver@neukum.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 2, 2010 at 3:29 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Dienstag, 2. Februar 2010 15:29:46 schrieb Roel Kluin:
>> If in a cold state and the download succeeded ret is zero, but we
>> should return -ENOMEM.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> Or shouldn't we?
>
> We should and we do if cold==0.
> The bug is caused by this:
>
>        if (cold) {
>                info("found a '%s' in cold state, will try to load a firmware",desc->name);
>                ret = dvb_usb_download_firmware(udev,props);
>                if (!props->no_reconnect || ret != 0)
>                        return ret;
>        }
>
> which overwrites ret

Is that an ack or do you want me to add an int (e.g. rc) that
handles the dvb_usb_download_firmware() return value?

Roel

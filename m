Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:33397 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756122Ab1IMUrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 16:47:41 -0400
Message-ID: <4E6FC167.4070505@yahoo.com>
Date: Tue, 13 Sep 2011 21:47:35 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com> <4E4FCC8D.3070305@redhat.com> <4E50FAC7.6080807@yahoo.com> <4E6FB736.4080202@iki.fi>
In-Reply-To: <4E6FB736.4080202@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/09/11 21:04, Antti Palosaari wrote:
> On 08/21/2011 03:32 PM, Chris Rankin wrote:
>> It occurred to me this morning that since we're no longer supposed to be
>> holding the device lock when taking the device list lock, then the
>> em28xx_usb_disconnect() function needs changing too.
>>
>> Signed-off-by: Chris Rankin <rankincj@yahoo.com>
>
> I ran that also when re-plugging both PCTV 290e and 460e as today LinuxTV 3.2
> tree. Seems like this patch is still missing and maybe some more.

There was also this patch, which fixed a couple of memory leaks:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg36432.html

IIRC, the main purpose of the other patch was to delete the 
em28xx_remove_from_devlist() function as well by adding the

     list_del(&dev->devlist);

to the em28xx_close_extension() function instead.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg35783.html

Cheers,
Chris

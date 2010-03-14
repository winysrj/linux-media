Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0CNSWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 14:22:42 -0400
Message-ID: <4B9D296C.1090901@redhat.com>
Date: Sun, 14 Mar 2010 15:22:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
References: <4B99104B.3090307@redhat.com> <20100311175214.GB7467@core.coreip.homeip.net> <4B99C3D7.7000301@redhat.com> <20100313084157.GD22494@core.coreip.homeip.net> <4B9BFCB6.4080805@redhat.com> <20100314063704.GB24684@core.coreip.homeip.net>
In-Reply-To: <20100314063704.GB24684@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sat, Mar 13, 2010 at 05:59:34PM -0300, Mauro Carvalho Chehab wrote:

>> It is representing it right:
>>
>> usb1/1-3 -> irrcv -> irrcv0 -> input7 -> event7
>>
>> The only extra attribute there is the class name "irrcv", but this seems
>> coherent with the other classes on this device (dvb, sound, power, video4linux).
>>
> 
> Ah, yes, I saw where you take input device's parent and use it as
> irrcv's parent but missed the piece where you substitute original
> input device's parent with irrcv. I bit sneaky to my taste but I guess
> can be cleaned up later.

Yes. I opted to do this little trick to avoid changing the interfaces
on the other modules, and to minimize the needs when porting from input.
We can later clean it if/when needed.

-- 

Cheers,
Mauro

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P95rpA023156
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 05:05:53 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [217.30.184.167])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3P95bkx015351
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 05:05:37 -0400
Message-ID: <49F2D25B.80801@iki.fi>
Date: Sat, 25 Apr 2009 12:05:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <49D644CD.1040307@powercraft.nl>	<49D64E45.2070303@powercraft.nl>	<49DC5033.4000803@powercraft.nl>	<49F1B2A4.3060404@powercraft.nl>
	<49F20259.1090302@iki.fi>	<49F2C312.4030808@powercraft.nl>
	<49F2C710.2000906@iki.fi> <49F2CFD5.5070101@powercraft.nl>
In-Reply-To: <49F2CFD5.5070101@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: one dvb-t devices not working with mplayer the other is, what
 is going wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 04/25/2009 11:54 AM, Jelle de Jong wrote:
> Hmm, I used the latest Debian kernel available in unstable and
> experimental, so I used the stock kernel. If this is to old I cant really
>   help this and have to wait until Debian releases a new kernel. There is
> no residue in my current kernel of any em28xx code its a complete clean
> stock Debian kernel.
>
> I don't know about the age of the firmware, but I believe its extracted
> from the kernel code it tells me:
> [ 4689.481452] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [ 4689.975618] af9013: firmware version:4.65.0

Firmware is not delivered with Kernel. You can download various firmware 
version from, but newest is the best. If you need remote and you have 
problems with remote you can test older ones.
http://palosaari.fi/linux/v4l-dvb/firmware/af9015/

> Ignore the em28xx devices they have proprietary code, and is not
> mainstream developed, no use wasting energy on that. Been there, done that.
>
> What is your kernel and firmware version? Is there a way to easily add a
> newer firmware file without recompilation?

Yes, it is only file usually in /lib/firmware/

According to attached log it does not lock to the 722000000 MHz. Could 
you try tzap -r "3FM(Digitenne)" and then mplayer /dev/dvb/adapter0/dvr0 
from other window whil tzap is running. tzap should inform if it locks 
and also some signal values.
There could be many reasons why it does not lock, most typical a little 
too weak signal. Is there any other stream in same frequency which works?

regards
Antti
-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

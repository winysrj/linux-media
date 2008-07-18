Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IA2RLs018378
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:02:27 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IA20MM009924
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:02:01 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJmmm-0001Ex-31
	for video4linux-list@redhat.com; Fri, 18 Jul 2008 12:02:00 +0200
Message-ID: <488069EC.7080207@hhs.nl>
Date: Fri, 18 Jul 2008 12:01:16 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Tim Farrington <timf@iinet.net.au>
References: <4880694A.3060002@iinet.net.au>
In-Reply-To: <4880694A.3060002@iinet.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, mchehab@infradead.org
Subject: Re: problem with latest v4l-dvb hg - videodev
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

Tim Farrington wrote:
> Hi Mauro, Hans,
> 
> I've just attempted a new install of ubuntu, then downloaded via hg the 
> current v4l-dvb,
> and installed it.
> 
> Upon reboot, the boot stalled just after loading the firmware at 
> something about incorrect
> videodev count.
> 
> It would not boot any further, and I was unable to save the dmesg to a 
> file (read only access)
> 
> I've had to reinstall ubuntu to be able to send this message.
> 

I've just hit the same problem and just committed a fix for this to my tree 
(and send a pull request to Mauro) if you do a hg clone from:
http://linuxtv.org/hg/~hgoede/v4l-dvb

You will get the latest v4l-dbd with my fix included.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

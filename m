Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IB7tgC018050
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 07:07:55 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au
	(outbound.icp-qv1-irony-out4.iinet.net.au [203.59.1.150])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IB7Z7D014572
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 07:07:42 -0400
Message-ID: <48807976.2070705@iinet.net.au>
Date: Fri, 18 Jul 2008 19:07:34 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <4880694A.3060002@iinet.net.au> <488069EC.7080207@hhs.nl>
In-Reply-To: <488069EC.7080207@hhs.nl>
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

Hans de Goede wrote:
> Tim Farrington wrote:
>> Hi Mauro, Hans,
>>
>> I've just attempted a new install of ubuntu, then downloaded via hg 
>> the current v4l-dvb,
>> and installed it.
>>
>> Upon reboot, the boot stalled just after loading the firmware at 
>> something about incorrect
>> videodev count.
>>
>> It would not boot any further, and I was unable to save the dmesg to 
>> a file (read only access)
>>
>> I've had to reinstall ubuntu to be able to send this message.
>>
>
> I've just hit the same problem and just committed a fix for this to my 
> tree (and send a pull request to Mauro) if you do a hg clone from:
> http://linuxtv.org/hg/~hgoede/v4l-dvb
>
> You will get the latest v4l-dbd with my fix included.
>
> Regards,
>
> Hans
>
OK, Yay! Both fixes seem the same, Used Hans de Goede's, all works fine now!

Many thanks,
Timf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

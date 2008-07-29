Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TAKos3011892
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 06:20:50 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TAKcWI030926
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 06:20:38 -0400
Message-ID: <488EEA42.2020907@hhs.nl>
Date: Tue, 29 Jul 2008 12:00:34 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com>
	<20080728221628.GB21280@vidsoft.de> <488E46BC.10104@gmail.com>
In-Reply-To: <488E46BC.10104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: [V4l2-library] Messed up syscall return value
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

Jiri Slaby wrote:
> On 07/29/2008 12:16 AM, Gregor Jasny wrote:
>> ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0x7fffbfda0060) = 2
>>
>> Huh? Something evils seems to be going on in V4L2 land.
>> I've spotted the following lines in videobuf-core.c:videobuf_reqbufs
>>
>>         req->count = retval;
>>
>>  done:
>>         mutex_unlock(&q->vb_lock);
>>         return retval;
>>
>> That would explain the retval '2'. It seems a retval = 0; statement is 
>> missing here for the success case.
>

Indeed, so iow I'm happy to conclude that thie is not a libv4l bug :)

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

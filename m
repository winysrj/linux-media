Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15AowVR004280
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 05:50:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15AoWjX004275
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 05:50:32 -0500
Date: Tue, 5 Feb 2008 08:49:51 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Andy McMullan" <andy@andymcm.com>
Message-ID: <20080205084951.1af2d725@gaivota>
In-Reply-To: <fea7c4860802041408j21689c54v568c976f4173a463@mail.gmail.com>
References: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
	<fea7c4860802030606v6614d884i1a5e71980709739f@mail.gmail.com>
	<20080204072233.073d40da@gaivota>
	<fea7c4860802041408j21689c54v568c976f4173a463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: bt878 'interference' on fc6 but not fc1
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

On Mon, 4 Feb 2008 22:08:24 +0000
"Andy McMullan" <andy@andymcm.com> wrote:

> > Maybe it have something to do with some power saving cycle at the processor.
> > You may try to change powersave governor policy and see the results.
> 
> Thanks for the suggestion.  I tried turning off the cpuspeed service,
> and even totally disabling acpi in the kernel, but it didn't make any
> difference.  (I don't know much about cpu throttling on linux, but I
> assume it relies on ACPI)

Just stopping a daemon wouldn't solve. 
You may try to do something like this:

echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor  

test, and test again with:

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor  

This link provides some additional info:
http://www.thinkwiki.org/wiki/How_to_make_use_of_Dynamic_Frequency_Scaling

There's an interesting tool that will help to see what is happening at
processor level. It is powertop:
http://www.lesswatts.org/projects/powertop/

The tool may help you to see the differences between the previous and the newer
setup.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

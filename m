Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5Q8gwOc028527
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 04:42:58 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5Q8gEB4028637
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 04:42:15 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KBn3V-0005Jr-RT
	for video4linux-list@redhat.com; Thu, 26 Jun 2008 10:42:13 +0200
Message-ID: <48635647.9060504@hhs.nl>
Date: Thu, 26 Jun 2008 10:41:43 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Gregor Jasny <jasny@vidsoft.de>
References: <4862BF41.9090208@hhs.nl> <20080626083915.GA18818@vidsoft.de>
In-Reply-To: <20080626083915.GA18818@vidsoft.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Announcing libv4l 0.1
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

Gregor Jasny wrote:
> Hi,
> 
> On Wed, Jun 25, 2008 at 11:57:21PM +0200, Hans de Goede wrote:
>> As most of you know I've been working on a userspace library which can be 
>> used to (very) easily add support for all kind of pixelformats to v4l2 
>> applications.
>>
>> Just replace open("dev/video0", ...) with v4l2_open("dev/video0", ...), 
>> ioctl
>> with v4l2_ioctl, etc. libv4l2 will then do conversion of any known (webcam)
>> pixelformats to bgr24 or yuv420.
> 
> I'll give the conversion and v4l2 userspace library a try during
> weekend. Is there a public rcs where I can pull updates from?
> 

Not yet, chances are this will become part of the v4l-dvb project, if not I'll 
create a sourceforge project page for it.

For now expect regular updated tarballs to be announced on the list, and you 
can always check:
http://people.atrpms.net/~hdegoede/

To see if there is a new tarbal there.

Thanks for the patch.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

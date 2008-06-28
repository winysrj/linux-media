Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SJVasg025593
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 15:31:36 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SJVOjZ014218
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 15:31:25 -0400
Message-ID: <486692F7.4040607@hhs.nl>
Date: Sat, 28 Jun 2008 21:37:27 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Gregor Jasny <jasny@vidsoft.de>
References: <48660D68.8040506@hhs.nl> <20080628172015.GG18818@vidsoft.de>
In-Reply-To: <20080628172015.GG18818@vidsoft.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: Announcing libv4l 0.2
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
> On Sat, Jun 28, 2008 at 12:07:36PM +0200, Hans de Goede wrote:
>> libv4l-0.2
>> ----------
>> *** API change ***
> 
> It would be usesul if you expose the library or api version in your
> public header files like for example OpenSSL in <openssl/opensslv.h>.
> So the develpers can keep their code backward compatible with some
> simple ifdefs.
> 

Actually the reason for this change is to make things so that an ABI change in 
the future will most likely not be necessary ever.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

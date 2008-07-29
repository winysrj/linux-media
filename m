Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TJf2He014657
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 15:41:02 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TJeoDC003642
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 15:40:51 -0400
Message-ID: <488F7447.6070503@hhs.nl>
Date: Tue, 29 Jul 2008 21:49:27 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Gregor Jasny <jasny@vidsoft.de>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com>
	<20080728221628.GB21280@vidsoft.de> <488E46BC.10104@gmail.com>
	<488EEA42.2020907@hhs.nl> <20080729115224.GD21280@vidsoft.de>
In-Reply-To: <20080729115224.GD21280@vidsoft.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
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

Gregor Jasny wrote:
> On Tue, Jul 29, 2008 at 12:00:34PM +0200, Hans de Goede wrote:
>> Indeed, so iow I'm happy to conclude that thie is not a libv4l bug :)
> 
> Will you add a work around like the above in libv4l?
> 

I don't like it much, but since Mauro thinks this is for the best I've added to 
my tree.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

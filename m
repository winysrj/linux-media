Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n368iD72014196
	for <video4linux-list@redhat.com>; Mon, 6 Apr 2009 04:44:13 -0400
Received: from www.tglx.de (www.tglx.de [62.245.132.106])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n368hX8i010319
	for <video4linux-list@redhat.com>; Mon, 6 Apr 2009 04:43:49 -0400
Date: Mon, 6 Apr 2009 10:43:18 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: chris h <chris123@magma.ca>
Message-ID: <20090406084317.GA3667@local>
References: <200904011827.49171.chris123@magma.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904011827.49171.chris123@magma.ca>
Cc: video4linux-list@redhat.com
Subject: Re: First post
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

On Wed, Apr 01, 2009 at 06:27:48PM -0400, chris h wrote:
> Greets:
> 
> Currently using xawtv to capture video from my USB webcam, Works just fine. 
> The only issue is that xawtv does not seem to capture audio from the same 
> webcam. Ive read the man pages and there doesnt seem to be a switch to direct 
> xawtv to source sound from the webcam. Was wondering if anyone can provide 
> any advise. 

You should have a look at the Wiki:

http://www.linuxtv.org/wiki/index.php/Webcams

Find out which driver your webcam is using, then find out if it supports
sound. I didn't deal with webcams in the last two years and don't know
what the current state-of-the-art is, but I think there are not many
drivers which support sound from a webcam.

Thanks,
Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

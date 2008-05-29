Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4THVfu9006315
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 13:31:41 -0400
Received: from smtp1.infomaniak.ch (smtp1.infomaniak.ch [84.16.68.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4THVDif027580
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 13:31:14 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 29 May 2008 19:39:27 +0200
References: <483ECEB2.7080005@cinnamon-sage.de>
In-Reply-To: <483ECEB2.7080005@cinnamon-sage.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291939.27737.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: How to enumerate video devices?
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

Hi Lars,

On Thursday 29 May 2008, Lars Hanisch wrote:
> Hi,
>
>   What is the best method to enumerate video devices, so that a program
> can display a list of present hardware in/outputs? Just iterating over
> /dev/video0 to /dev/videoSomeHighNumber seems a bit 'unprofessional'.
>
>   (BTW I'm also looking for the right way of enumerating framebuffer
> devices...)
>
>   I didn't find anything in the api-spec nor at google (perhaps I had
> the wrong searchphrases?).
>
>   Please enlighten me. ;-)

Check /sys/class/video4linux

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

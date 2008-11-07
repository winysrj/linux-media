Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA74UQ58005718
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 23:30:26 -0500
Received: from QMTA09.westchester.pa.mail.comcast.net
	(qmta09.westchester.pa.mail.comcast.net [76.96.62.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA74UDxa024795
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 23:30:14 -0500
Message-ID: <4913C455.3030501@personnelware.com>
Date: Thu, 06 Nov 2008 22:30:13 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <26aa882f0810280714u1b3964b9t1440369d2d2a36b7@mail.gmail.com>	<200811060142.48227.laurent.pinchart@skynet.be>
	<26aa882f0811061612r1419b6a1p9dd8f17333be09ba@mail.gmail.com>
In-Reply-To: <26aa882f0811061612r1419b6a1p9dd8f17333be09ba@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: Testing Requested: Python Bindings for Video4linux2
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

Jackson Yee wrote:
> Lauren,
> 
> On Wed, Nov 5, 2008 at 7:42 PM, Laurent Pinchart
> <laurent.pinchart@skynet.be> wrote:
>> The uvcvideo driver doesn't implement the standard ioctls. This should not be
>> fatal (and you probably want to define FindKeyas well).
> 
> The standard ioctls are, unfortunately, all I have to go by since I'm
> testing on my amd64 box with a bttv card.

and vivi.  I wish more people would test against vivi.  although right now I
would hold off, cuz there is a nasty memory leak in one of vivi.c, capture.c or
the newer capture_example.c - details:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/294951 - I am guessing vivi.

> If a function does not
> succeed though, it should throw an exception and let the user code
> sort things out. Do you have a link for the uncvideo driver so I could
> add support for it?
> 
> FindKey looks to be Carl's code. ;-) I've added the function now.

I'll take responsibility for that, cuz it make it look like I am doing something
 kinda useful :)

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

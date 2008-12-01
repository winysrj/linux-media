Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1IVBBn007810
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:31:11 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1IUwWL002776
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:30:59 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
	<1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0812011458230.3915@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 01 Dec 2008 19:30:42 +0100
In-Reply-To: <Pine.LNX.4.64.0812011458230.3915@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	1 Dec 2008 14\:59\:23 +0100 \(CET\)")
Message-ID: <87wseju4rx.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add all yuv format combinations.
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Tue, 4 Nov 2008, Robert Jarzmik wrote:
>
>> The Micron mt9m111 offers 4 byte orders for YCbCr
>> output. This patchs adds all possible outputs capabilities
>> to the mt9m111 driver.
>> 
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>
> Robert, could you please confirm, that this patch is still correct?
Yes, confirmed.

I'm using it for some time now, without modification.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

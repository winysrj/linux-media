Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2A7WZMZ011565
	for <video4linux-list@redhat.com>; Wed, 10 Mar 2010 02:32:35 -0500
Received: from gateway.tuioptics.com (gateway.tuioptics.com [213.183.22.85])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2A7WJ7h028911
	for <video4linux-list@redhat.com>; Wed, 10 Mar 2010 02:32:20 -0500
Date: Wed, 10 Mar 2010 08:29:53 +0100
From: Arno Euteneuer <arno.euteneuer@toptica.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <4B974A71.5030506@toptica.com>
In-Reply-To: <Pine.LNX.4.64.1003092256140.4891@axis700.grange>
References: <4B960AE2.3090803@toptica.com>
References: <Pine.LNX.4.64.1003092256140.4891@axis700.grange>
Subject: Re: soc-camera driver for i.MX25
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thanks for your interest!

> Nice, thanks for the patch! Now, you'd have to formalise the submission -
> add your Signed-off-by line, provide a suitable patch description.
Ok. That sounds like the easy part ;)

 > More
> importantly, it certainly has to be updated for 2.6.32 and 2.6.33 - the
> biggest change since 2.6.31 has been the conversion to the v4l2-subdev
> API, and a smaller one - the addition of the mediabus API.
I already suspected that I have to update it :D Currently I'm using a 2.6.31 
kernel that has been patched with a BSP from the board supplier. So, I have to 
first update these patches in order to be able to run my system with a current 
kernel,I guess. I will try that ...

> For a single
> driver these are not very big changes, I could help you with them, but you
> certainly would have to re-test your setup with the current kernel. Would
> you be able to do that? And then, of course, we'd also have to pass your
> driver through the usual review rounds.
>
Thanks for your encouraging answer. I never before submitted a driver and any 
help is highly appreciated.

Thanks
Arno

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

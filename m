Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DHLXbV014423
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 13:21:33 -0400
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7DHKmLv015271
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 13:21:17 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
	<1218621820.48a2b17c963cd@imp.free.fr>
	<Pine.LNX.4.64.0808131322340.3884@axis700.grange>
	<87skt86fb9.fsf@free.fr>
	<Pine.LNX.4.64.0808131845200.7458@axis700.grange>
	<87hc9o6eks.fsf@free.fr>
	<Pine.LNX.4.64.0808131911330.7713@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 13 Aug 2008 19:20:46 +0200
In-Reply-To: <Pine.LNX.4.64.0808131911330.7713@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed\,
	13 Aug 2008 19\:12\:43 +0200 \(CEST\)")
Message-ID: <87iqu44ys1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: style cleanup
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

> And in mt9m111_resume()? Do you want to check return codes of each 
> function there too?
Yes, in mt9m111_resume() too, please.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

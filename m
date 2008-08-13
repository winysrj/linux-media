Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DA45aW000553
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 06:04:05 -0400
Received: from wmproxy1-g27.free.fr (wmproxy1-g27.free.fr [212.27.42.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7DA3tcq026756
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 06:03:55 -0400
Message-ID: <1218621820.48a2b17c963cd@imp.free.fr>
Date: Wed, 13 Aug 2008 12:03:40 +0200
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0808131105020.3884@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] soc_camera: endianness between camera and its host
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

Selon Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

> Hm, I would just do this during format-enumeration... I'll try to sketch
> something maybe today.
Great !

> > [RFC]
> I think, we might manage to get it a bit simpler.
Even better :)

> As for your mt9m111 patch - unfortunately, during my first quick review I
> missed a few more minor formatting issues, so, because it is kinda my
> fault, my plan is to apply your patch as it is, and then I can just post
> for your ack a clean-up patch. And then, as we get format negotiation in
> place, you can extend it with further supported formats. What do you
> think?
Very good idea. Let's do it that way, it's perfect for me.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA77wXj4007847
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:58:33 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA77wKqp011342
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:58:20 -0500
Date: Fri, 7 Nov 2008 08:58:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: fpantaleao@mobisensesystems.com
In-Reply-To: <20081107072226.4sfvw4jxssckckgo@webmail.hebergement.com>
Message-ID: <Pine.LNX.4.64.0811070839040.4513@axis700.grange>
References: <20081107072226.4sfvw4jxssckckgo@webmail.hebergement.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: About CITOR register value for pxa_camera
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

On Fri, 7 Nov 2008, fpantaleao@mobisensesystems.com wrote:

> > On Thu, 6 Nov 2008, fpantaleao@mobisensesystems.com wrote:
> > 
> > > Sure we can do it that way if the sensor is clocked by MCLK and no
> > > prescale is
> > > done by the sensor.
> > > In other cases, PCLK is controlled by sensor:
> > > - sensor has its own clock
> > > - MCLK is prescaled by the sensor.
> > 
> > Right, then maybe we should request the sensor what quotient it's running
> > its pixel clock respective our master clock? In the master mode, of course.
> 
> To be more general (sensor clocked by MCLK or not), I think we should request
> the sensor its PCLK, by adding a get_pclk member in soc_camera_ops for
> example.

Yes, that should be even better, and pass master-clock frequency as a 
parameter? What shall we take for default? pclk == mclk or some safe 
conservative value? Don't think requiring every camera driver to provide 
this method would be very good.

Another question, are there situations, when a sensor might decide to 
change its pixelclock dynamically? Then it might need to inform the host 
driver about the change?

> Then CITOR value can be computed.
> On the sensor side, PCLK value can be defined in its platform data. I agree
> this is redundant for a MT9V022 clocked by MCLK but to my point of view, this
> is not the general case.

Ack.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

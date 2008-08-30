Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7U7mjiq013151
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 03:48:45 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7U7mX5C001287
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 03:48:33 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080829183420.1fcbfc11@mchehab.chehab.org>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl> <48B7E8C4.5060605@nokia.com>
	<200808291543.27863.hverkuil@xs4all.nl>
	<20080829183420.1fcbfc11@mchehab.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 30 Aug 2008 09:22:44 +0200
Message-Id: <1220080964.1736.55.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Sakari Ailus <sakari.ailus@nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] soc-camera: add API documentation
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

On Fri, 2008-08-29 at 18:34 -0300, Mauro Carvalho Chehab wrote:
	[split]
> At the other side of the coin, we have lots of drivers that don't use any API
> to split sensors from the bridge drivers, being GSPCA the newest example. I
> believe that splitting sensors from bridge drivers will benefit to reduce the
> amount of coding size on such drivers, and help to fix bugs that are common to
> several webcams. Of course, such conversion would be a huge task.

I think this subject was already discussed.

If you look at the gspca code, you will see that many sensors are used
by different bridges. Indeed, some values are closed from each other,
but what to do with the differences? (the initial values of the sensor
registers seem to be tied to the physical wires, signal levels and
capabilities of the bridges)

Also, the way to load the sensor registers is very different from one
bridge to an other one (direct write, with one or many values in one
write, paging, bridge packets with different headers/tails..).

Eventually, looking again at the code, you will see that the sensor
exchanges are only a small part of the code.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBMAUj50006811
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 05:30:45 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBMAU5Yq026836
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 05:30:06 -0500
Date: Mon, 22 Dec 2008 11:30:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
In-Reply-To: <20081222093250.GM22230@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812221120260.5241@axis700.grange>
References: <20081218170015.10DD88E03CC@hormel.redhat.com>
	<44440.83878.qm@web32104.mail.mud.yahoo.com>
	<20081222093250.GM22230@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Agustin <gatoguan-os@yahoo.com>, video4linux-list@redhat.com,
	Sascha Hauer <sha@pengutronix.de>
Subject: Re: soc-camera: current stack
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

On Mon, 22 Dec 2008, Robert Schwebel wrote:

> Hi Agustin,
> 
> On Fri, Dec 19, 2008 at 03:58:46AM -0800, Agustin wrote:
> > I was about to try this stack on my Phytec i.MX31 system when I found
> > there is no mx3_camera driver in it. Too bad!
> 
> We are working hard on a mainline quality patch series for the
> phyCORE-i.MX31 and a bunch of these patches already went into the
> maintainer trees for the 2.6.29 merge window.
> 
> One of the next central components is the pmic driver, which hasn't
> reached mainline quality yet. If that's finished, camera drivers will
> surely be in a better situation wrt. mainline.

pmic is good, although, I don't remember it affecting the camera driver 
_directly_, so, I think, it is perfectly possible to have a good camera 
driver with no PMIC support. As you know, PMIC is a separate IC, and shall 
be handled by a separate (regulator?) driver. As you write - your PMIC 
driver will be relevant for the phyCORE board, and not necessarily so for 
other designs. So, I don't think this affects the chances of the imx31 
camera driver to be included in the mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

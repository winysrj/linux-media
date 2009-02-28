Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:21722 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933AbZB1FUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 00:20:52 -0500
Message-ID: <49A8C9A9.2040607@rogers.com>
Date: Sat, 28 Feb 2009 00:20:41 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "U. Artie Eoff" <uartie@gmail.com>
CC: video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: ASUS My Cinema-PHC3-100/NAQ/FM/AV/RC Support?
References: <6b3e6cdb0902271139w176708c9t67b32dca960aa6c4@mail.gmail.com>
In-Reply-To: <6b3e6cdb0902271139w176708c9t67b32dca960aa6c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

U. Artie Eoff wrote:
> I recently purchased a ASUS My Cinema-PHC3-100/NAQ/FM/AV/RC ATSC tv tuner
> card.  I've done some searching to see what kind of support is available for
> using it under Linux.  There is nothing out there that mentions it will work
> or how to get it to work.  And it does not appear that my Fedora OS detects
> it installed.  Could someone start me off with some steps on getting it
> configured (i.e. drivers, detecting, loading, configuring, etc.).  I
> consider myself a somewhat advanced user of Linux, but have never done any
> direct work with tuner cards or general low-level hardware configuration
> under Linux.  So, don't hesitate to explain in technical terms if it is
> easier.
>   

suscipio lackius -- a technical term, derived from Coyote and Road
Runner Latin, which literally translates into "support lacking" or, from
a contemporary perspective, "not supported".  Sorry.  Hopefully the
humour eased the pain.

> Anyway, here is the product link for my card:
> http://www.asus.com/products.aspx?l1=18&l2=83&l3=794
> ...and product image:
> http://www.asus.com/prog_content/middle_enlargement.aspx?model=2524
>   

>From your provided link, it is apparent that this is another variation
of the ViXS Puretv reference design(s).  Up to this point, in PCI
flavour, I had only seen a half height card design.  Examples:
- Vista View Saber DA-1N1-I (http://www.vistaview.tv/saber-da-1n1-i.html)
- Samsung Combo-210
(http://www.geeks.com/details.asp?invtid=COMBO-210-BULK&cat=VID)
- ViXS PureTV-U 48A3 (
http://www.linuxtv.org/wiki/index.php/ViXS_PureTV-U_48A3) 

As I've seen a couple of other PureTV-U model numbers listed (without
actually having seen the cards), it is likely that your full height PCI
card is the equivalent of one of them.  I would go a step further and
call your card pretty much a PCI hybrid of the Samsung type PCIe design;
have a look at:
- Vista View Saber DA-1N1-E (http://www.vistaview.tv/content/view/51/116/)
- Samsung Combo-210E
(http://tekgems.com/Products/et-46138-vid-combo-210e-bulk.htm)

Note that with the Vista View PCIe card, it looks like the LG demod is
on the front face. (In the half height PCI design, the LG demod is on
the back side of the card). 
In the Samsung PCIe card, there is a much smaller chip in the spot where
the LG demod resides on the Vista View PCIe version.  Similarly, your
card also appears to copy the Samsung layout/componentry....with the
minor exceptions related to the difference in interface

I suggest contacting ViXS and inquire as to whether they intend to
provide Linux support for their chip; there is some evidence that
suggests that they may very well be interested
(http://www.vixs.com/sections/careers/job_software_driver_engineer.htm). 
Other then that, I suspect that the other components used by the card
already have driver support, or are presently being worked upon (i.e.
saa7136) in conjunction for other projects.  Once those individual items
are all supported, device level support would certainly be feasible to
obtain.




Return-path: <linux-media-owner@vger.kernel.org>
Received: from legolas.alcom.aland.fi ([194.112.1.132]:48894 "EHLO
	legolas.alcom.aland.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZLEJpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 04:45:13 -0500
Received: from aragon.alcom.aland.fi (aragon [194.112.0.1])
	by legolas.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id nB59jIKc017106
	for <linux-media@vger.kernel.org>; Sat, 5 Dec 2009 11:45:18 +0200
Received: from [10.0.0.2] (82-199-168-58.bredband.aland.net [82.199.168.58])
	(authenticated bits=0)
	by aragon.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id nB59jGiU016807
	for <linux-media@vger.kernel.org>; Sat, 5 Dec 2009 11:45:16 +0200
Subject: Re: af9015: tuner id:179 not supported, please report!
From: Jan Sundman <jan.sundman@aland.net>
To: linux-media@vger.kernel.org
In-Reply-To: <37219a840912041003o4d8ebe27wbe3f1c47f55ba7dc@mail.gmail.com>
References: <1259695756.5239.2.camel@desktop>
	 <loom.20091202T230047-299@post.gmane.org>
	 <37219a840912021508s75535fa6v83006d3bad0c301@mail.gmail.com>
	 <1259874920.2151.13.camel@desktop>
	 <41ef408f0912031347j6b9a704flc6d9c302f4e0517@mail.gmail.com>
	 <829197380912031403l6b828821q87f407fa95bc25f9@mail.gmail.com>
	 <37219a840912041003o4d8ebe27wbe3f1c47f55ba7dc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 11:45:10 +0200
Message-ID: <1260006310.3702.3.camel@desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Thanks for the info, I will have a look and see if it is worth the
trouble. 

Br,

// Jan

On Fri, 2009-12-04 at 13:03 -0500, Michael Krufky wrote:
> On Thu, Dec 3, 2009 at 5:03 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> > On Thu, Dec 3, 2009 at 4:47 PM, Bert Massop <bert.massop@gmail.com> wrote:
> >> Hi Jan,
> >>
> >> The datasheet for the TDA18218 can be obtained from NXP:
> >> http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf
> >>
> >> That's all the information I have at the moment, maybe Mike has some
> >> other information (like the Application Note mentioned in the
> >> datasheet, that claims to contain information on writing drivers, but
> >> cannot be found anywhere).
> >>
> >> Best regards,
> >>
> >> Bert
> >
> > Took a quick look at that datasheet.  I would guess between that
> > datasheet and a usbsnoop, there is probably enough there to write a
> > driver that basically works for your particular hardware if you know
> > what you are doing.  The register map is abbreviated, but probably
> > good enough...
> >
> > Devin
> 
> The datasheet is missing too much important information needed to
> write a fully featured driver for the part, and I wouldn't recommend
> using a usbsnoop for this type of tuner, but be my guest and prove me
> wrong.
> 
> You might be able to get it working, but you'll end up with tons of
> binary blobs hardcoded for each frequency, unless you use a
> programming guide.  Unfortunately, I don't have one that I can share
> :-/
> 
> I think you would be much better off purchasing supported hardware, instead.
> 
> Good luck, though...
> 
> -Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



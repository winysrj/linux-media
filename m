Return-path: <mchehab@gaivota>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46383 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0LNKkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:40:04 -0500
Received: by yxt3 with SMTP id 3so233066yxt.19
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 02:40:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikzXXAn2pZqP6F03ywnCfke-Amb51NZnx2=-oU0@mail.gmail.com>
References: <AANLkTikzXXAn2pZqP6F03ywnCfke-Amb51NZnx2=-oU0@mail.gmail.com>
From: Richard Hartmann <richih.mailinglist@gmail.com>
Date: Tue, 14 Dec 2010 11:39:43 +0100
Message-ID: <AANLkTi=+Wc5Pk_mMkG7NwWvK7Pt5q6P=DcZ48qcD6kdM@mail.gmail.com>
Subject: Re: Request for linux drivers for IDS uEye USB cameras -- we will
 ship you the hardware and you can keep it
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

while the email to got delivered to prjmgr@linuxdriverproject.org &
linux-kernel@vger.kernel.org the attachment made the linux-media list
eat this mail.

Resending verbatim without attachment.


Richard

On Wed, Dec 8, 2010 at 13:16, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:
> Hi all,
>
> as Hans de Goede does not have enough free time to go after this, he
> asked me to poke the V4L list. As this also concerns Linux in general,
> I am sending to the Linux Driver Project as well. [0] says to mail
> prjmgr@ for new projects so I am doing that. Finally, I wasn't sure if
> mailing LKML would reach people who might reasonably be interested in
> this offer yet miss it due to not reading the other two lists. I am
> still unsure but decided to default to the save option especially as
> one additional email to LKML is a drop in an insanely-sized bucket,
> anyway.
>
>
> We have two USB cameras by IDS Imaging [1], the uEye XS [2] and the
> uEye LE [3] which require a proprietary blob [4] to run under Linux.
> There is an user-space API of questionable usefulness. We would prefer
> native V4L support which actually works over said Linux "solution".
>
>
> The USB IDs are:
>
> Bus 002 Device 007: ID 1409:1645  #  uEye U|164xLE-C
> Bus 002 Device 002: ID 1409:1008  #  uEye U|1008XS-C (seems to be a
> Sony package meant for phones with IDS stuff around it)
>
> The full output lsusb -v can be found at
> http://paste.debian.net/100555/ - the first entry is my mouse :p
>
>
> The text on chips on the LE is:
>
> CY22150FZ
> XC
> 1007 A 02
> 609214
>
> 2400P
> ED4Ca
>
> 464WP
> K018
>
> Output from usbmon [5] is attached. It's only 344 kiB in size so I
> decided to attach it for everyone's convenience. In case any list
> filters out attachments, just poke me and I'll send them your way.
>
>
> More stuff:
>
> * We will ship the cameras we bought to you. Preferably to a location
> where shipping costs are not insane; Europe preferred. You keep the
> cameras; they are yours.
> * You try and get pictures out of the cams. We don't need HD or
> anything. Our use case is criminal investigation so pics don't need to
> be print perfect.
> * The XS has auto focus and can somewhat dynamically adapt to
> different lighting situations. Ideally, this should work.
> * Hans will advise us on who of the volunteers, if any, are best
> suited for this. I don't know the V4L community; he does. If we get
> volunteers via the Linux Driver Project, I don't know how people are
> selected, but I am happy to go with whatever they propose.
> * While we know that no guarantees of any kind can be made, we
> obviously prefer fast results over slower ones. If someone has gobs of
> time available and is looking for a end-of-year project, that is a
> huge plus :p That being said, we don't expect miracles.
> * As the cameras were not cheap, we would appreciate, but do not
> require, a short mention in the initial commit message[s].
>
> As an aside, if anyone can point us to any small (around thumb size or
> smaller) cameras, both with really wide angle and narrow angle, that
> connect via USB, FireWire, or Ethernet and are well-supported under
> Linux... we are all ears. The pictures will need to be fed into
> zoneminder, other than that, we don't really care how we get the pics
> as long as it's reliable and supported for the longer term. One would
> assume that dozens of webcams would fit the bill, but most of the ones
> I could find have been EOLed for ages.
>
>
> Thanks,
> Richard
>
> [0] http://www.linuxdriverproject.org/foswiki/bin/view/Main/MailingLists
> [1] http://www.ids-imaging.com/
> [2] http://www.ids-imaging.com/frontend/products.php?cam_id=125
> [3] http://www.ids-imaging.com/frontend/products.php?cam_id=48
> [4] http://www.ueyesetup.de/frontend/files/uEyeupdater/Setup_e.htm
> [5] http://people.redhat.com/zaitcev/linux/usbmon-6.tar.gz
>



-- 
Richard

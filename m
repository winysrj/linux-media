Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:46188 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0AXSvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 13:51:13 -0500
Date: Sun, 24 Jan 2010 13:12:58 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] sq905c: remove unused variable and other topics
In-Reply-To: <20100124091815.185cb889@tele>
Message-ID: <alpine.LNX.2.00.1001241238450.13083@banach.math.auburn.edu>
References: <68cac7521001231550i40f4b28fy3d073c043e4027e2@mail.gmail.com> <alpine.LNX.2.00.1001231909070.12296@banach.math.auburn.edu> <20100124091815.185cb889@tele>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 24 Jan 2010, Jean-Francois Moine wrote:

> On Sat, 23 Jan 2010 19:44:06 -0600 (CST)
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
>
>> If everyone else is agreeable, I would propose that the recent
>> changes to sq905c.c should simply be pulled, and that is the best
>> solution to the problem.
>
> A pull request for this change has been sent last sunday.

Jean-Francois,

Thanks.

I would also like to address three other items.

1. For a long time I was not getting the mail from this list. I could 
not figure out what was the matter, but I finally remember what happened:

I went on a two week vacation last summer, and I unsubscribed before I 
left home, since I did not want to deal with what seemed like several 
hundred messages a day piling up unread in my inbox. Then when I got back 
I was too busy trying to catch up with work to remember to resubscribe. 
Fixed, now.


2. I hope that when you got the sq905c changes that you also pulled the 
changes for mr97310a.c. Several things have been done there recently.

First, there was a patch to the initialization for one of the types of 
supported cameras. Without that patch the camera will work only on a host 
machine with OHCI USB support and will fail to stream when hooked to a 
host machine with a UHCI controller. There was a desperate, last minute 
attempt to get this patch into 2.6.32, the urgency of which apparently 
failed to convince the higher-ups and it did not get in. The only excuse 
for the bad timing is the obvious one, that who could imagine that such a 
problem could occur until actually confronted with it? It is just too 
weird. I do not know the current status of this patch.

Second, other cleanups have been done to mr97310a.c

Third, another camera with yet another init sequence and control 
capabilities has been discovered, and it is added to mr97310a.c

I would say that the most recent version of the mr97310a driver is the 
best and most bug-free of the versions, and I hope it gets used.

3. The sn9c2028 driver. It runs the three sn9c2028 cameras that I have on 
hand and does so pretty well.

I would characterize the driver as unfinished, though. For, there are at 
least two cameras supported there which I do not and never did personally 
own, and therefore I cannot test them. I do have init sequences which are 
based upon snoops previously done, and I put those in the driver. 
Unfortunately, I have been unable to get anyone else to test those two 
cameras, either. Apparently, the only way to get them tested is to send 
the driver mainstream. After that, perhaps I will get reports whether they 
work, or not!

The two cameras in question which are untested or are incompletely tested 
are (quoting from sn9c2028.c)

         {USB_DEVICE(0x0458, 0x7005)}, /* Genius Smart 300, version 2 */
         /* The Genius Smart is untested. I can't find an owner ! */

and

         {USB_DEVICE(0x0c45, 0x8008)}, /* Mini-Shotz ms-350 */

where the owner tells me that the code I sent him works, but he can not do 
more testing right now because he is too busy (wife is having first 
child). The Mini-Shotz has obvious redundancies and bactrackings in the 
init sequence which is used in the OEM driver. I would very much like to 
be able to clean out all the crud which is in the OEM init sequence, but I 
have no way to know exactly what is needed, without testing.

Thus, if anyone who reads this has either of the above sn9c2028 cameras or 
any other one which is not currently supported at all, please contact me. 
There is a lot of unfinished business with the sn9c2028 driver. I would 
very much like for it to get done. But said work depends upon finding 
owners and testers.


Theodore Kilgore

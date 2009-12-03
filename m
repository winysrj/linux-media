Return-path: <linux-media-owner@vger.kernel.org>
Received: from thsmsgxrt13p.thalesgroup.com ([192.54.144.136]:39193 "EHLO
	thsmsgxrt13p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbZLCR66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 12:58:58 -0500
Message-ID: <4B17FBE6.7040606@thalesgroup.com>
Date: Thu, 03 Dec 2009 18:56:54 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2] Another approach to IR
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Em Thu, 3 Dec 2009 11:50:04 -0500
> Jon Smirl <jonsmirl@gmail.com> escreveu:
>
> > On Thu, Dec 3, 2009 at 11:33 AM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> > > Ferenc Wagner wrote:
> > >> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> > >>
> > >>> Dmitry Torokhov wrote:
> > >>>
> > >
> > >> The interesting thing is that input.h defines KEY_TV, KEY_PC, KEY_SAT,
> > >> KEY_CD, KEY_TAPE etc., but no corresponding scan codes will ever be sent
> > >> by any remote (ok, I'm stretching it a bit).
> > >
> > > Unfortunately, this is not true. Some IR's do send a keycode for TV/PC/SAT/CD, etc.
> > >
> > > On those remotes, if you press TV and then press for example Channel UP
> > > and press Radio, then press Channel UP, the channel UP code will be the same.
> > >
> > > For example, on Hauppauge Grey IR, we have:
> > >
> > > <TV>
> > > [13425.128525] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e1c keycode 0x179
> > > [13425.136733] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=1
> > > [13425.144170] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=0
> > >
> > > <CHANNEL UP>
> > > [13428.350223] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
> > > [13428.358434] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
> > > [13428.365871] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0
> > >
> > > <Radio>
> > > [13430.672266] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e0c keycode 0x181
> > > [13430.680473] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=1
> > > [13430.687913] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=0
> > >
> > > <CHANNEL UP>
> > > [13433.697268] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
> > > [13433.705480] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
> > > [13433.712916] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0
> > >
> > > In this IR, the address is bogus: it is always 0x1e. This scenario is very common with the
> > > shipped IR's.
> > 
> > The remote is treating everything as a single integrated device which
> > is not inconsistent with what has been said. In this case there really
> > is only one multi-function device not two independent ones.
> > 
> > If you want to control two independent devices you need to buy a
> > different remote. Remotes are cheap so that's not a big deal.
> > 
> > If you really want to use this remote to control two independent
> > devices you need user space scripting to split the single device into
> > two devices and then inject new events into the input layer. This is a
> > complex case and not in the goal of getting 90% of users to "just
> > work".
>
> This remote is a typical example of the IR's that are provided together with media boards.
> On all such IR's I know, it does generate one key event for TV, SAT, DVB, DVD... keys and
> this event doesn't change the status of subsequent keys.
>
> 100% of the users of such boards will have the shipped IR. Some amount will be happy of
> just using the provided IR to control different applications at their computer or embedded
> hardware, and some amount will prefer to buy a multi-purpose IR that will allow him
> to control not only his computer, but also, his TV, his Air conditioning, etc.
>
> Both usages should be supported.
>
> All I'm saying is that, in the case where people have only the shipped IR, if he wants to
> see TV, the produced keycode will be KEY_TV, and then to change a channel, it will
> receive KEY_CHANNELUP, to control his TV app. When the user decides to switch to DVB, 
> he will press KEY_DVB and then KEY_PLAY to play his movie.
>
> So, an application like MythTV should be able to work with those keys.
>   
Eeeerrrkkk, what a ...... device .
For such quirky device, we could imagine a special mapping support:
We could maps scancode 0x1e1c and 0x1e0c special keycode wich inform the 
input layer to surcharge the  vendor or device with a specific 
value/mask for following  keypresses of such remote. The mask could be 
choose to generate out of bound value in regards of the used protocol 
for the vendor or the device part to not overlap with another existing 
remote.
Generate a complete map and so a device for each special key and you're 
done. No special case on the application side.
In kernel states are a bit ugly, but this particular case is not too 
complicated and your dumb shitty remote is promoted to first class one.


Regards,
Emmanuel.



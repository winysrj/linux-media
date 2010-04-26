Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52661 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004Ab0DZOdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 10:33:46 -0400
Reply-To: <michael.parker@st.com>
From: Michael PARKER <michael.parker@st.com>
To: <linux-media@vger.kernel.org>
Cc: "'Daniel Kristjansson'" <danielk@cuymedia.net>
Subject: RE: Ticket #5744: Initial tuning to an analogue station fault
Date: Mon, 26 Apr 2010 15:33:19 +0100
Message-ID: <565E4FC366F04FF69EA0A938C4705888@st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

I could really do with someone able to interpret the following descriptions into a bugfix picking this issue up.

Attached to bug:

> CloseChannel here is called with with the only file descriptor open on the video device. On certain tv cards at least, > closing that single connection will initiate a sleep state of the analogue frontend with loss of all previous 
> tuning detail. In order to fix this, the CloseChannel call is moved to a later point where it is known that the video 
> device has been opened for reading elsewhere.

Contributed by Daniel Kristjansson, MythTv dev:

> It looks like the problem is that the driver is not allowing multiple
> open calls to it's file handle. It should be allowing opens for ioctl's 
> even if it only allows one open for reading.

As I've said previously, I believe the problem relates to the cx8800 driver/module. It affects users of the Hauppauge HVR-4000 card trying to view any of the analogue outputs (RF/S-Video/Composite) through MythTV's "Watch TV" function.

A valid patch (to the MythTV source) is attached to the ticket, but the MythTV devs are reluctant to apply what's seen as a workaround for an upstream V4L issue.

Daniel: If you can provide any additional information, I'd be most grateful if you could step in right around now.

Many thanks in advance,

Mike

> -----Original Message-----
> From: Mike Parker [mailto:michael.parker@st.com] 
> Sent: Friday, April 23, 2010 12:29 PM
> To: 'linux-media@vger.kernel.org'
> Subject: Ticket #5744: Initial tuning to an analogue station fault
> 
> Hi,
> 
> Apologies for the nube ignorance/vagueness but....
> 
> I'm seeking a bugfix to (I believe) the cx8800 module, 
> related to an issue I experienced in MythTV 
> (http://svn.mythtv.orgs/trac/ticket/5744). The MythTV devs are 
> reluctant to incorporate the patch attached to the bug since 
> they believe it is a workaround for an upstream V4L issue. 
> Hence my mail to this list.
> 
> The following is a mail written to Gerd Knorr (who I believe 
> to be the the author of the cx8800 driver/module), seeking 
> assistance with this bugfix. At the foot of the email trail 
> is a brief description of what is believed to be the issue 
> (written by Daniel Kristjansson). Having found various 
> statements suggesting Gerd is no longer involved with V4L, I 
> though I'd repost here.
> 
> NB. I've yet to receive confirmation that it is actually the 
> cx8800 module (and not some dependency of the cx8800 module) 
> that requires fixing. All I know is that MythTV reports that 
> it is using the cx8800 driver.
> 
> FYI, I'm picking up the V4L modules from kernel 
> v2.6.32.11-99. My system is running x86_64 Fedora 12. My 
> video capture card is a Hauppague HVR-4000
> 
> Any help anyone can give would be greatly appreciated.
> 
> Mike
> 
> ---
> 
> Gerd,
> 
> Apologies for the direct email, but I'm trying to track down 
> the person responsible for, I believe, the V4L cx8800 driver/module.
> 
> I'm attempting to find a resolution for 
> http://svn.mythtv.org/trac/ticket/5744, an issue which has 
> wasted several hours of my time recently as I've struggled to 
> get live TV in Myth working on my HVR-4000 card.
> 
> As the ticket describes, the MythTV devs are unwilling to 
> integrate this patch as they see it as a workaround for a V4L 
> driver bug (briefly described below by Daniel Kristjansson).
> 
> Are you the correct person to implement a fix for the cx8800 driver?
> 
> NB. As you can doubtless tell from this and previous mails, 
> I'm operating well out of my depth here. I'm just trying to 
> get an issue solved that has cost me time and will probably 
> cost others time in the months/years to come. If you can help 
> in any way to move this issue closer to resolution, I'd be 
> very grateful.
> 
> If you need any information, logs etc. from me, just let me 
> know what I need to do and I'll do my best to provide you 
> with the information you need.
> 
> Obviously, if you're not the correct recipient of this mail, 
> I'd appreciate you passing it onto to whoever you believe to 
> be the correct recipient.
> 
> Best regards,
> 
> Mike
> 
> -----Original Message-----
> From: Mike Parker [mailto:michael.parker@st.com] 
> Sent: Thursday, April 22, 2010 1:35 PM
> To: 'Daniel Kristjansson'
> Cc: 'Janne'
> Subject: RE: Ticket #5744: Initial tuning to an analogue station fault
> 
> <snip>
> 
> > It looks like the problem is that the driver is not 
> allowing multiple
> > open calls to it's file handle. It should be allowing opens 
> for ioctl's 
> > even if it only allows one open for reading. The driver probably has
> > the name of the person who maintains the driver in it's 
> source files in
> > the copyright notice. Try e-mailing that person. We work with many
> > drivers so we don't want to add special code to interface with each
> > one's quirks unless it's on a limited time basis. When we add a
> > workaround we need the driver name and the version the problem is
> > fixed in. We write the hack so it is only used for those 
> older drivers
> > and remove the workaround after one to two years.
> > 
> > -- Daniel
> 
> Thanks for getting back to me. First off, I understand and 
> agree with your position re. the inclusion of workarounds.
> 
> Excuse my ignorance (I'm a relative newbie to Linux) but 
> which driver are we talking about? 
> 
> Myth BE log reports that it's using the cx8800 driver, which 
> I assume references the common v4l_common(?) module/driver 
> via the dependency tree illustrated in the output of 'lsmod'. 
> Is this even roughly correct?
>  
> Am I correct in thinking, therefore, that the driver that 
> requires a bugfix is the cx8800 driver? i.e. the driver 
> specific to the hardware on the HVR-4000 card?
> 
> Also, when we talk about "driver", are we really talking 
> about the kernel module (*.ko, IIRC)?
> 
> Looking at the copyright notice in one of the cx88 src files, 
> it looks as if Gerd Knorr <kraxel@bytesex.org> is the contact 
> I'm looking for.
> 
> Best regards,
> 
> Mike
> 
> 
> 
> 
> 


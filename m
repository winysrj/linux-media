Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:59556 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662Ab0DWLzw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 07:55:52 -0400
Received: from zeta.dmz-eu.st.com (ns2.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 362991DF
	for <linux-media@vger.kernel.org>; Fri, 23 Apr 2010 11:28:46 +0000 (GMT)
Received: from mail1.bri.st.com (mail1.bri.st.com [10.65.7.198])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D8FA81962
	for <linux-media@vger.kernel.org>; Fri, 23 Apr 2010 11:28:45 +0000 (GMT)
Reply-To: <michael.parker@st.com>
From: Michael PARKER <michael.parker@st.com>
To: <linux-media@vger.kernel.org>
Subject: Ticket #5744: Initial tuning to an analogue station fault
Date: Fri, 23 Apr 2010 12:28:45 +0100
Message-ID: <0F58E1C80A7B4382AFE160E84CD025F3@st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Apologies for the nube ignorance/vagueness but....

I'm seeking a bugfix to (I believe) the cx8800 module, related to an issue I experienced in MythTV (http://svn.mythtv.org/trac/ticket/5744). The MythTV devs are reluctant to incorporate the patch attached to the bug since they believe it is a workaround for an upstream V4L issue. Hence my mail to this list.

The following is a mail written to Gerd Knorr (who I believe to be the the author of the cx8800 driver/module), seeking assistance with this bugfix. At the foot of the email trail is a brief description of what is believed to be the issue (written by Daniel Kristjansson). Having found various statements suggesting Gerd is no longer involved with V4L, I though I'd repost here.

NB. I've yet to receive confirmation that it is actually the cx8800 module (and not some dependency of the cx8800 module) that requires fixing. All I know is that MythTV reports that it is using the cx8800 driver.

FYI, I'm picking up the V4L modules from kernel v2.6.32.11-99. My system is running x86_64 Fedora 12. My video capture card is a Hauppague HVR-4000

Any help anyone can give would be greatly appreciated.

Mike

---

Gerd,

Apologies for the direct email, but I'm trying to track down the person responsible for, I believe, the V4L cx8800 driver/module.

I'm attempting to find a resolution for http://svn.mythtv.org/trac/ticket/5744, an issue which has wasted several hours of my time recently as I've struggled to get live TV in Myth working on my HVR-4000 card.

As the ticket describes, the MythTV devs are unwilling to integrate this patch as they see it as a workaround for a V4L driver bug (briefly described below by Daniel Kristjansson).

Are you the correct person to implement a fix for the cx8800 driver?

NB. As you can doubtless tell from this and previous mails, I'm operating well out of my depth here. I'm just trying to get an issue solved that has cost me time and will probably cost others time in the months/years to come. If you can help in any way to move this issue closer to resolution, I'd be very grateful.

If you need any information, logs etc. from me, just let me know what I need to do and I'll do my best to provide you with the information you need.

Obviously, if you're not the correct recipient of this mail, I'd appreciate you passing it onto to whoever you believe to be the correct recipient.

Best regards,

Mike

-----Original Message-----
From: Mike Parker [mailto:michael.parker@st.com] 
Sent: Thursday, April 22, 2010 1:35 PM
To: 'Daniel Kristjansson'
Cc: 'Janne'
Subject: RE: Ticket #5744: Initial tuning to an analogue station fault

<snip>

> It looks like the problem is that the driver is not allowing multiple
> open calls to it's file handle. It should be allowing opens for ioctl's 
> even if it only allows one open for reading. The driver probably has
> the name of the person who maintains the driver in it's source files in
> the copyright notice. Try e-mailing that person. We work with many
> drivers so we don't want to add special code to interface with each
> one's quirks unless it's on a limited time basis. When we add a
> workaround we need the driver name and the version the problem is
> fixed in. We write the hack so it is only used for those older drivers
> and remove the workaround after one to two years.
> 
> -- Daniel

Thanks for getting back to me. First off, I understand and agree with your position re. the inclusion of workarounds.

Excuse my ignorance (I'm a relative newbie to Linux) but which driver are we talking about? 

Myth BE log reports that it's using the cx8800 driver, which I assume references the common v4l_common(?) module/driver via the dependency tree illustrated in the output of 'lsmod'. Is this even roughly correct?
 
Am I correct in thinking, therefore, that the driver that requires a bugfix is the cx8800 driver? i.e. the driver specific to the hardware on the HVR-4000 card?

Also, when we talk about "driver", are we really talking about the kernel module (*.ko, IIRC)?

Looking at the copyright notice in one of the cx88 src files, it looks as if Gerd Knorr <kraxel@bytesex.org> is the contact I'm looking for.

Best regards,

Mike






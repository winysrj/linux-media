Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:4379 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3CFK1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 05:27:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: volokh84@gmail.com
Subject: Re: tw2804.c
Date: Wed, 6 Mar 2013 11:27:18 +0100
Cc: linux-media@vger.kernel.org
References: <20130305194828.8A75511E00AE@alastor.dyndns.org> <201303061102.47933.hverkuil@xs4all.nl> <20130306101124.GA1916@VPir.1>
In-Reply-To: <20130306101124.GA1916@VPir.1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303061127.18113.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 6 March 2013 11:11:24 volokh84@gmail.com wrote:
> On Wed, Mar 06, 2013 at 11:02:47AM +0100, Hans Verkuil wrote:
> > On Wed 6 March 2013 10:48:13 volokh84@gmail.com wrote:
> > > Hi,
> > > Hans
> > > 
> > > I found in d8077d2df184f3ef63ed9ff4579d41ca64e12855 commit,
> > > that V4L2_CTRL_FLAG_VOLATILE flag was disabled for some STD controls
> > > and fully disabled g_ctrl iface. So How can userspace know about changing some values?
> > 
> > VOLATILE is used when register values can change automatically (e.g. if
> > autogain is on and the device regulates the gain and updates that gain
> > register itself).
> >
> Right that!!!
> there one register for all 4 channell for each of AUTOGAIN,CHROMA,RED_B,BLUE_B reg, so if one channel changes CHROMA value (it changes all 4 channels),
> the another channel will have cached old value, instead new (case it value have not volatile control)

Ah, yes. Good point. I need to modify the code to have two control handlers:
one for the global controls and one for the channel controls. That's the right
way to do this. I'll implement that later this week.

Regards,

	Hans

> > However, testing proved that the hardware doesn't update anything when
> > in autogain mode, hence volatile support isn't needed.
> > 
> > Note that the control framework always caches the last control value,
> > so to get non-volatile controls the framework just returns that cached
> > value.
> > 
> > Regards,
> > 
> > 	Hans
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

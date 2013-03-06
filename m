Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:63195 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab3CFKLL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 05:11:11 -0500
Date: Wed, 6 Mar 2013 14:11:24 +0400
From: volokh84@gmail.com
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: volokh84@gmail.com, linux-media@vger.kernel.org
Subject: Re: tw2804.c
Message-ID: <20130306101124.GA1916@VPir.1>
References: <20130305194828.8A75511E00AE@alastor.dyndns.org>
 <20130306094813.GA1888@VPir.1>
 <201303061102.47933.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303061102.47933.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 06, 2013 at 11:02:47AM +0100, Hans Verkuil wrote:
> On Wed 6 March 2013 10:48:13 volokh84@gmail.com wrote:
> > Hi,
> > Hans
> > 
> > I found in d8077d2df184f3ef63ed9ff4579d41ca64e12855 commit,
> > that V4L2_CTRL_FLAG_VOLATILE flag was disabled for some STD controls
> > and fully disabled g_ctrl iface. So How can userspace know about changing some values?
> 
> VOLATILE is used when register values can change automatically (e.g. if
> autogain is on and the device regulates the gain and updates that gain
> register itself).
>
Right that!!!
there one register for all 4 channell for each of AUTOGAIN,CHROMA,RED_B,BLUE_B reg, so if one channel changes CHROMA value (it changes all 4 channels),
the another channel will have cached old value, instead new (case it value have not volatile control)
> However, testing proved that the hardware doesn't update anything when
> in autogain mode, hence volatile support isn't needed.
> 
> Note that the control framework always caches the last control value,
> so to get non-volatile controls the framework just returns that cached
> value.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42237 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab2DFLrz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 07:47:55 -0400
Message-ID: <4F7ED7E9.203@iki.fi>
Date: Fri, 06 Apr 2012 14:47:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: DVB ioctl FE_GET_EVENT behaviour broken in 3.3
References: <4F7CDA41.5020001@googlemail.com> <4F7ECA22.7040604@yahoo.com>
In-Reply-To: <4F7ECA22.7040604@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.04.2012 13:49, Chris Rankin wrote:
> The reason that DVB playback with xine is broken in 3.3 is that the
> userspace semantics of FE_GET_EVENT have changed. Xine tunes into a DVB
> channel as follows:
>
> * discards stale frontend events by calling FE_GET_EVENT until there is
> none left.
> * calls FE_SET_FRONTEND with the new frequency.
> * starts polling for new frontend events by calling FE_GET_EVENT again.
>
> Xine assumes that *every* FE_GET_EVENT after calling FE_SET_FRONTEND
> will have dvb_frontend_event.parameters.frequency set to the new
> frequency, if this channel exists. However, under Linux 3.3, at least
> the first new event with a newly-plugged-in device has a frequency
> parameter of zero. I am assuming that Linux is populating the frequency
> parameter from an internal data structure because xine behaves normally
> once some other DVB application manages to set it to something other
> than zero. And xine then continues to behave normally until I unplug the
> DVB adapter and plug in back in again.
>
> So the question is: why is there no frequency for this first
> FE_GET_EVENT? Are the parameters incomplete, or shouldn't this event
> have been sent in the first place?

I have no enough experience, but IMHO all frontend parameters should be 
available just after demod is LOCKed. Before LOCK you cannot know many 
parameters at all and frequency also can be changed a little bit during 
tuning process (ZigZag tuning algo).

Could you try to git bisect to find out patch causing that regression?

I suspect it is some change done for DVB core, git log 
drivers/media/dvb/dvb-core/ shows rather many patches that could be the 
reason.

regards
Antti
-- 
http://palosaari.fi/

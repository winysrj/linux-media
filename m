Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34110 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1KAMts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2011 08:49:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Date: Tue, 1 Nov 2011 13:49:46 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com> <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
In-Reply-To: <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111011349.47132.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rémi,

On Tuesday 01 November 2011 13:36:50 Rémi Denis-Courmont wrote:
> On Tue, 1 Nov 2011 13:24:35 +0100, Laurent Pinchart wrote:
> > We should instead fix the V4L2 specification to mandate the use of a
> > monotonic clock (which could then also support hardware timestamps when
> > they are available). Would such a change be acceptable ?
> 
> I'd rather have the real time clock everywhere, than a driver-dependent
> clock, if it comes to that.

That's my opinion as well. Modifying drivers to use a monotonic clock is easy, 
and I can provide patches. The real issue is whether this can be accepted, as 
it would change the spec.

> Nevertheless, I agree that the monotonic clock is better than the real
> time clock.
> In user space, VLC, Gstreamer already switched to monotonic a while ago as
> far as I know.
> 
> And I guess there is no way to detect this, other than detect ridiculously
> large gap between the timestamp and the current clock value?

That's right. We could add a device capability flag if needed, but that 
wouldn't help older applications that expect system time in the timestamps.

-- 
Regards,

Laurent Pinchart

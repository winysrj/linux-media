Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46977 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1KSTkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 14:40:45 -0500
Received: by ghbz2 with SMTP id z2so1654014ghb.19
        for <linux-media@vger.kernel.org>; Sat, 19 Nov 2011 11:40:45 -0800 (PST)
Date: Sat, 19 Nov 2011 16:40:37 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, moinejf@free.fr
Subject: Re: [PATCH] [media] gspca: replaced static allocation by
 video_device_alloc/video_device_release
Message-ID: <20111119194037.GA3709@localhost>
References: <20111119185015.GA3048@localhost>
 <4EC80176.5000802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC80176.5000802@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 19, 2011 at 08:20:22PM +0100, Hans de Goede wrote:
> Hi,
> 
> On 11/19/2011 07:50 PM, Ezequiel wrote:
> > Pushed video_device initialization into a separate function.
> > Replaced static allocation of struct video_device by
> > video_device_alloc/video_device_release usage.
> 
> NACK! I see a video_device_release call here, but not a
> video_device_alloc, also you're messing with quite sensitive code
> here (because a usb device can be unplugged at any time, including
> when the /dev/video node is open by a process), and changing it
> from static to dynamic allocation my have more consequences
> then you see at first (I did not analyze all the code paths
> for the proposed change, since the last time I audited them for
> the current static allocation of the videodevice struct code took
> me hours).
> 
> Also static allocation (as part of the driver struct) in general is
> better then dynamic as it needs less code and helps avoiding memory
> fragmentation.
> 
> All in all I cannot help but feel that you're diving into a piece
> of code with some drive by shooting style patch without knowing
> the code in question at all, please don't do that!
> 
> Regards,
> 
> Hans
> 

Hi Hans,

Sorry, really dont know what happened, 
I sent an incomplete patch version.
(some vim yank-key error).

I understand your observations about static vs dynamic, 
but please could you review the right patch.

Thanks,
Ezequiel.

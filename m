Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GDhOqQ029034
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 09:43:24 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GDgeaA021548
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 09:42:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 16 Mar 2008 14:42:37 +0100
References: <patchbomb.1205671781@liva.fdsoft.se>
In-Reply-To: <patchbomb.1205671781@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161442.37610.hverkuil@xs4all.nl>
Cc: Frej Drejhammar <frej.drejhammar@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features.
	Version 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sunday 16 March 2008 13:49, Frej Drejhammar wrote:
> The cx2388x family of broadcast decoders all have features not
> enabled by the standard cx88 driver. This revised patch series adds
> controls allowing the chroma AGC and the color killer to be enabled
> (Version 1 of the series used module parameters). By default both
> features are disabled as in previous versions of the driver.
>
> The Chroma AGC and the color killer is sometimes needed when using
> signal sources of less than optimal quality.
>
> The patches applies cleanly to 7370:11fdae6654e8 of
> http://linuxtv.org/hg/v4l-dvb/ and have been tested an a HVR-1300.
> The patches should be applied in order.

Hi Frej,

I have a few comments about this:

1) Should we really expose these settings to the user? I have my doubts 
whether the average user would know what to do with this, and I also 
wonder whether it makes enough of a difference in picture quality. I 
might be wrong, of course. It would help if you could show examples of 
the picture quality with and without these settings. Note that a change 
like 'Chroma AGC must be disabled if SECAM is used' is a bug fix and 
should clearly go in.

2) Chroma AGC and color killer is also present in other chips (cx2584x, 
cx23418, possibly other similar Conexant chips). So if we decide on 
allowing these controls I would prefer making this a standard control, 
rather than a private one.

3) If we decide on allowing these controls, then they must be documented 
in the v4l2 spec.

Personally I think these controls are too low-level, but that's just my 
opinion. Most chips contains a whole array of similar tweaks that you 
can do, and exposing them all is not the way to go.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

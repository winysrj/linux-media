Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35855 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbaKKSFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 13:05:44 -0500
Message-ID: <54624FF1.2060102@xs4all.nl>
Date: Tue, 11 Nov 2014 19:05:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
In-Reply-To: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2014 06:46 PM, Andrey Utkin wrote:
> At Bluecherry, we have issues with servers which have 3 solo6110 cards
> (and cards have up to 16 analog video cameras connected to them, and
> being actively read).
> This is a kernel which I tested with such a server last time. It is
> based on linux-next of October, 31, with few patches of mine (all are
> in review for upstream).
> https://github.com/krieger-od/linux/ . The HEAD commit is
> 949e18db86ebf45acab91d188b247abd40b6e2a1 at the moment.
> 
> The problem is the following: after ~1 hour of uptime with working
> application reading the streams, one card (the same one every time)
> stops producing interrupts (counter in /proc/interrupts freezes), and
> all threads reading from that card hang forever in
> ioctl(VIDIOC_DQBUF). The application uses libavformat (ffmpeg) API to
> read the corresponding /dev/videoX devices of H264 encoders.
> Application restart doesn't help, just interrupt counter increases by
> 64. To help that, we need reboot or programmatic PCI device reset by
> "echo 1 > /sys/bus/pci/devices/0000\:03\:05.0/reset", which requires
> unloading app and driver and is not a solution obviously.
> 
> We had this issue for a long time, even before we used libavformat for
> reading from such sources.
> A few days ago, we had standalone ffmpeg processes working stable for
> several days. The kernel was 3.17, the only probably-relevant change
> in code over the above mentioned revision is an additional bool
> variable set in solo_enc_v4l2_isr() and checked in solo_ring_thread()
> to figure out whether to do or skip solo_handle_ring(). The variable
> was guarded with spin_lock_irqsave(). I am not sure if it makes any
> difference, will try it again eventually.
> 
> Any thoughts, can it be a bug in driver code causing that (please
> point which areas of code to review/fix)? Or is that desperate
> hardware issue? How to figure out for sure whether it is the former or
> the latter?

I would first try to exclude hardware issues: since you say it is always
the same card, try either replacing it or swapping it with another solo
card and see if the problem follows the card or not. If it does, then it
is likely a hardware problem. If it doesn't, then it suggests a race
condition in the interrupt handling somewhere.

Regards,

	Hans

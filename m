Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1123 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3E2O0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:26:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: Keene
Date: Wed, 29 May 2013 16:26:20 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <5167513D.60804@iki.fi> <201304190912.06319.hverkuil@xs4all.nl> <51710A3F.10909@iki.fi>
In-Reply-To: <51710A3F.10909@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305291626.20170.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 19 2013 11:11:27 Antti Palosaari wrote:
> On 04/19/2013 10:12 AM, Hans Verkuil wrote:
> > On Wed April 17 2013 21:45:24 Antti Palosaari wrote:
> >> On 04/15/2013 09:55 AM, Hans Verkuil wrote:
> >>> On Fri April 12 2013 02:11:41 Antti Palosaari wrote:
> >>>> Hello Hans,
> >>>> That device is working very, thank you for it. Anyhow, I noticed two things.
> >>>>
> >>>> 1) it does not start transmitting just after I plug it - I have to
> >>>> retune it!
> >>>> Output says it is tuned to 95.160000 MHz by default, but it is not.
> >>>> After I issue retune, just to same channel it starts working.
> >>>> $ v4l2-ctl -d /dev/radio0 --set-freq=95.16
> >>>
> >>> Can you try this patch:
> >>>
> >>
> >> It does not resolve the problem. It is quite strange behavior. After I
> >> install modules, and modules are unload, plug stick in first time, it
> >> usually (not every-time) starts TX. But when I replug it without
> >> unloading modules, it will never start TX. Tx is started always when I
> >> set freq using v4l2-ctl.
> >
> > If you replace 'false' by 'true' in the cmd_main, does that make it work?
> > I'm fairly certain that's the problem.
> 
> Nope, I replaces all 'false' with 'true' and problem remains. When 
> modules were unload and device is plugged it starts TX. When I replug it 
> doesn't start anymore.
> 
> I just added msleep(1000); just before keene_cmd_main() in .probe() and 
> now it seems to work every-time. So it is definitely timing issue. I 
> will try to find out some smallest suitable value for sleep and and sent 
> patch.

Have you had time to find a smaller msleep value?

Regards,

	Hans

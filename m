Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43626 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2E1JsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 05:48:10 -0400
Date: Mon, 28 May 2012 11:48:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
Message-ID: <20120528114803.0d1a4881@stein>
In-Reply-To: <1338137803-12231-1-git-send-email-mchehab@redhat.com>
References: <4FC24E34.3000406@redhat.com>
	<1338137803-12231-1-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On May 27 Mauro Carvalho Chehab wrote:
> The Kconfig building system is improperly selecting some drivers,
> like analog TV tuners even when this is not required.
> 
> Rearrange the Kconfig in a way to prevent that.
> 
> Mauro Carvalho Chehab (3):
>   media: reorganize the main Kconfig items
>   media: Remove VIDEO_MEDIA Kconfig option
>   media: only show V4L devices based on device type selection

On 1/3 "media: reorganize the main Kconfig items":

a) I agree with Sylvester that the MEDIA_WEBCAM_SUPP variable, prompt
text, and help text should be worded a bit more general.  Wouldn't this
variable also cover industrial cameras and who knows what other kinds of
video inputs?  I also agree with Sylvester about the SUPP vs. SUPPORT
thing.

b) Small typo in the MEDIA_ANALOG_TV_SUPP help text:  of -> or.

c) The RC_CORE_SUPP help text gives the impression that RC core is
always needed if there is hardware with an IR feature.  But the firedtv
driver is a case where the driver directly works on top of the input
subsystem rather than on RC core.  Maybe there are more such cases.
(Currently we don't ask whether FireDTV owners want IR support; we
silently build the IR part of firedtv in if CONFIG_INPUT is set, and
silently omit the IR part of firedtv if CONFIG_INPUT was disabled, which
requires CONFIG_EXPERT.)

How about turning the "Remote Controller support" option into merely a
filter for standalone IR and RF receivers and transmitters, whereas
Kconfig options in the analog and digital TV categories silently do
"select RC_CORE if INPUT" for combined tuner + IR/RF rx/tx hardware?
-- 
Stefan Richter
-=====-===-- -=-= ===--
http://arcgraph.de/sr/

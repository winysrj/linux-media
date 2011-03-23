Return-path: <mchehab@pedra>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:36500 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab1CWNro convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 09:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110322175810.GA32416@linux-sh.org>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
 <4D88E1FB.5070503@redhat.com> <20110322175810.GA32416@linux-sh.org>
From: "K, Mythri P" <mythripk@ti.com>
Date: Wed, 23 Mar 2011 19:17:20 +0530
Message-ID: <AANLkTinjEmih3GC9FMByUCcLVvcc1k1PCzVECbQZa62f@mail.gmail.com>
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Paul,

On Tue, Mar 22, 2011 at 11:28 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Mar 22, 2011 at 02:52:59PM -0300, Mauro Carvalho Chehab wrote:
>> Em 22-03-2011 14:32, Mythri P K escreveu:
>> > Adding support for common EDID parsing in kernel.
>> >
>> > EDID - Extended display identification data is a data structure provided by
>> > a digital display to describe its capabilities to a video source, This a
>> > standard supported by CEA and VESA.
>> >
>> > There are several custom implementations for parsing EDID in kernel, some
>> > of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
>> > parsing of EDID should be done in a library, which is agnostic of the
>> > framework (V4l2, DRM, FB)  which is using the functionality, just based on
>> > the raw EDID pointer with size/segment information.
>> >
>> > With other RFC's such as the one below, which tries to standardize HDMI API's
>> > It would be better to have a common EDID code in one place.It also helps to
>> > provide better interoperability with variety of TV/Monitor may be even by
>> > listing out quirks which might get missed with several custom implementation
>> > of EDID.
>> > http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
>> >
>> > This patch tries to add functions to parse some portion EDID (detailed timing,
>> > monitor limits, AV delay information, deep color mode support, Audio and VSDB)
>> > If we can align on this library approach i can enhance this library to parse
>> > other blocks and probably we could also add quirks from other implementation
>> > as well.
>> >
>> > Signed-off-by: Mythri P K <mythripk@ti.com>
>> > ---
>> >  arch/arm/include/asm/edid.h |  243 ++++++++++++++++++++++++++++++
>> >  drivers/video/edid.c        |  340 +++++++++++++++++++++++++++++++++++++++++++
>>
>> Hmm... if you want this to be agnostic, the header file should not be inside
>> arch/arm, but on some other place, like include/video/.
>>
> Ironically this adds a drivers/video/edid.c but completely ignores
> drivers/video/edid.h which already exists and already contains many of
> these definitions.
>
> I like the idea of a generalized library, but it would be nice to see the
> existing edid.h evolved and its users updated incrementally.
>
well yes , That could be enhanced and that would take care of Mauro's
comment too.

Thanks and regards,
Mythri.

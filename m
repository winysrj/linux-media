Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0E1Tls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 15:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <4C001643.2070802@gmx.de>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
	<AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
	<Pine.LNX.4.64.1005270809110.2293@axis700.grange>
	<AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
	<Pine.LNX.4.64.1005272216380.1703@axis700.grange>
	<AANLkTikTBFPxbl5p9kI65bHt2UJZ5j0DAxFwJ6rzD77L@mail.gmail.com>
	<4C001643.2070802@gmx.de>
Date: Fri, 28 May 2010 15:41:46 -0400
Message-ID: <AANLkTimHM66vREdBf60D1jrgvFLDOjf3f3KcHjy6cYSR@mail.gmail.com>
Subject: Re: Idea of a v4l -> fb interface driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 28, 2010 at 3:15 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> Alex Deucher schrieb:
>>
>> On Fri, May 28, 2010 at 4:21 AM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>>>
>>> On Thu, 27 May 2010, Alex Deucher wrote:
>>>
>>>>
>>>> Another API to consider in the drm kms (kernel modesetting) interface.
>>>>  The kms API deals properly with advanced display hardware and
>>>> properly handles crtcs, encoders, and connectors.  It also provides
>>>> fbdev api emulation.
>>>
>>> Well, is KMS planned as a replacement for both fbdev and user-space
>>> graphics drivers? I mean, if you'd be writing a new fb driver for a
>>> relatively simple embedded SoC, would KMS apriori be a preferred API?
>>
>> It's become the defacto standard for X and things like EGL are being
>> built onto of the API.  As for the kms vs fbdev, kms provides a nice
>> API for complex display setups with multiple display controllers and
>> connectors while fbdev assumes one monitor/connector/encoder per
>> device.  The fbdev and console stuff has yet to take advantage of this
>> flexibility, I'm not sure what will happen there.  fbdev emulation is
>> provided by kms, but it has to hide the complexity of the attached
>> displays.  For an soc with a single encoder and display, there's
>> probably not much advantage over fbdev, but if you have an soc that
>> can do TMDS and LVDS and possibly analog tv out, it gets more
>> interesting.
>
> Well hiding complexity is actually the job of an API. I don't see any need
> for major changes in fbdev for complex display setups. In most cases as a
> userspace application you really don't want to be bothered how many
> different output devices you have and control each individually, you just
> want an area to draw and to know/control what area the user is expected to
> see and that's already provided in fbdev.

Users want to be able to dynamically change their display config on the fly.

> If the user wants the same content on multiple outputs just configure the
> driver to do so.

KMS provide an API to do that and a nice internal abstraction for handling it.

> If he wants different (independent) content on each output, just provide
> multiple /dev/fbX devices. I admit that we could use a controlling interface
> here that decides which user (application) might draw at a time to the
> interface which they currently only do if they are the active VT.
> If you want 2 or more outputs to be merged as one just configure this in the
> driver.
> The only thing that is impossible to do in fbdev is controlling 2 or more
> independent display outputs that access the same buffer. But that's not an
> issue I think.
> The things above only could use a unification of how to set them up on
> module load time (as only limited runtime changes are permited given that we
> must always be able to support a mode that we once entered during runtime).
>

What about changing outputs on the fly (turn off VGA, turn on DVI,
switch between multi-head and single-head, etc) or encoders shared
between multiple connectors (think a single dac shared between a VGA
and a TV port); how do you expose them easily as separate fbdevs?
Lots of stuff is doable with fbdev, but it's nicer with kms.

Alex

> The thing that's really missing in fbdev is a way to allow hardware
> acceleration for userspace.
>
>
> Regards,
>
> Florian Tobias Schandinat
>
>

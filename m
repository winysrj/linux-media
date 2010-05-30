Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43064 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0E3LPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 07:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <20100528200604.GA10135@sci.fi>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
	<AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
	<Pine.LNX.4.64.1005270809110.2293@axis700.grange>
	<AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
	<Pine.LNX.4.64.1005272216380.1703@axis700.grange>
	<AANLkTikTBFPxbl5p9kI65bHt2UJZ5j0DAxFwJ6rzD77L@mail.gmail.com>
	<4C001643.2070802@gmx.de>
	<AANLkTimHM66vREdBf60D1jrgvFLDOjf3f3KcHjy6cYSR@mail.gmail.com>
	<20100528200604.GA10135@sci.fi>
Date: Sun, 30 May 2010 21:15:50 +1000
Message-ID: <AANLkTilxszYcsfGp5GqY3hf02NMfN-eSy449oaGSykkW@mail.gmail.com>
Subject: Re: Idea of a v4l -> fb interface driver
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>
Cc: Alex Deucher <alexdeucher@gmail.com>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 29, 2010 at 6:06 AM, Ville Syrjälä <syrjala@sci.fi> wrote:
> On Fri, May 28, 2010 at 03:41:46PM -0400, Alex Deucher wrote:
>> On Fri, May 28, 2010 at 3:15 PM, Florian Tobias Schandinat
>> > If he wants different (independent) content on each output, just provide
>> > multiple /dev/fbX devices. I admit that we could use a controlling interface
>> > here that decides which user (application) might draw at a time to the
>> > interface which they currently only do if they are the active VT.
>> > If you want 2 or more outputs to be merged as one just configure this in the
>> > driver.
>> > The only thing that is impossible to do in fbdev is controlling 2 or more
>> > independent display outputs that access the same buffer. But that's not an
>> > issue I think.
>> > The things above only could use a unification of how to set them up on
>> > module load time (as only limited runtime changes are permited given that we
>> > must always be able to support a mode that we once entered during runtime).
>> >
>>
>> What about changing outputs on the fly (turn off VGA, turn on DVI,
>> switch between multi-head and single-head, etc) or encoders shared
>> between multiple connectors (think a single dac shared between a VGA
>> and a TV port); how do you expose them easily as separate fbdevs?
>> Lots of stuff is doable with fbdev, but it's nicer with kms.
>
> But actually getting your data onto the screen is a lot easier with
> fbdev. There's no standard API in drm to actually allocate the
> framebuffer and manipulate it. You always need a user space driver
> to go along with the kernel bits.
>
> I'm not saying fbdev is better than drm/kms but at least it can be
> used to write simple applications that work across different
> hardware. Perhaps that's something that should be addressed in the
> drm API.
>

http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg48461.html

I started writing a "dumb" API for KMS, it got stuck on whether to
expose cursors or not, I must dig out the branch.

It basically was a create + map API. I'll see if I can get it finished off.

The main reason we avoided a fully generic interface is there isn't
really a generic way to abstract acceleration on a modern GPU, and
buffer allocation on most modern GPUs doesn't want a linear simple
buffer. We felt doing a compromised generic interface would lead
people down the wrong path into believing they could easily move from
the "dumb" interface to a real accelerated one.

There is a userspace library called libkms that abstracts this stuff,
but I'd like to just have the kernel do it.

Dave.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756586Ab0E1T7C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 15:59:02 -0400
Message-ID: <4C002082.6030006@gmx.de>
Date: Fri, 28 May 2010 21:58:58 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Alex Deucher <alexdeucher@gmail.com>,
	Jaya Kumar <jayakumar.lkml@gmail.com>,
	linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange> <AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com> <Pine.LNX.4.64.1005270809110.2293@axis700.grange> <AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com> <Pine.LNX.4.64.1005272216380.1703@axis700.grange> <AANLkTikTBFPxbl5p9kI65bHt2UJZ5j0DAxFwJ6rzD77L@mail.gmail.com> <4C001643.2070802@gmx.de> <Pine.LNX.4.64.1005282124060.27251@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1005282124060.27251@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski schrieb:
> On Fri, 28 May 2010, Florian Tobias Schandinat wrote:
> 
>> Well hiding complexity is actually the job of an API. I don't see any need for
>> major changes in fbdev for complex display setups. In most cases as a
>> userspace application you really don't want to be bothered how many different
>> output devices you have and control each individually, you just want an area
>> to draw and to know/control what area the user is expected to see and that's
>> already provided in fbdev.
>> If the user wants the same content on multiple outputs just configure the
>> driver to do so.
>> If he wants different (independent) content on each output, just provide
>> multiple /dev/fbX devices. I admit that we could use a controlling interface
>> here that decides which user (application) might draw at a time to the
>> interface which they currently only do if they are the active VT.
>> If you want 2 or more outputs to be merged as one just configure this in the
>> driver.
>> The only thing that is impossible to do in fbdev is controlling 2 or more
>> independent display outputs that access the same buffer. But that's not an
>> issue I think.
>> The things above only could use a unification of how to set them up on module
>> load time (as only limited runtime changes are permited given that we must
>> always be able to support a mode that we once entered during runtime).
>>
>> The thing that's really missing in fbdev is a way to allow hardware
>> acceleration for userspace.
> 
> How about a "simple" use-case, that I asked about in another my mail: how 
> do you inform fbdev users, if a (DVI) display has been disconnected and 
> another one with a different resolution has been connected?

Yes that's a problem. The thing is that the virtual terminal requires us 
to always be able to switch to a resolution we once supported. Probably 
what I would do in such a case is switching the screen off and let the 
user figure out that he has done something "wrong". As we don't really 
know our users (applications) there is not much we can do but wait for 
the next check_var to solve this. So yes things that force us to be 
incompatible with our previous behaviour can do some harm if the user is 
not aware of it.

Note 1: Interesting that you mentioned viafb, the driver that is 
currently nearly completely incapable to determine any output device 
limitations.

Note 2: set_par returns a value but that's rather a mistake and we can't 
rely anyone to react on a sane way on error. check_var is the only place 
where framebuffers can say that they don't support something after this 
they have to support it regardless of any external events.


Thanks,

Florian Tobias Schandinat


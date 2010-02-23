Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1057 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0BWOmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 09:42:03 -0500
Message-ID: <afc23983d22d02e5832ce68b75f35890.squirrel@webmail.xs4all.nl>
In-Reply-To: <1266934843.4589.20.camel@palomino.walls.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
    <201002222254.05573.hverkuil@xs4all.nl>
    <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
    <201002230853.36928.hverkuil@xs4all.nl>
    <1266934843.4589.20.camel@palomino.walls.org>
Date: Tue, 23 Feb 2010 15:41:41 +0100
Subject: Re: Chroma gain configuration
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@radix.net>
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tue, 2010-02-23 at 08:53 +0100, Hans Verkuil wrote:
>> On Monday 22 February 2010 23:00:32 Devin Heitmueller wrote:
>> > On Mon, Feb 22, 2010 at 4:54 PM, Hans Verkuil <hverkuil@xs4all.nl>
>> wrote:
>
>> > Of course, if you and Mauro wanted to sign off on the creation of a
>> > new non-private user control called V4L2_CID_CHROMA_GAIN, that would
>> > also resolve my problem.  :-)
>>
>> Hmm, Mauro is right: the color controls we have now are a bit of a mess.
>> Perhaps this is a good moment to try and fix them. Suppose we had no
>> color
>> controls at all: how would we design them in that case? When we know
>> what we
>> really need, then we can compare that with what we have and figure out
>> what
>> we need to do to make things right again.
>
> Hmmm:
>
> 1. comb filter enable/disable
> 2. chroma AGC enable/disable
> 3. chroma kill threshold and enable/disable
> 4. UV saturation  (C vector magnitude adjustment as long as you adjust U
> and V in the same way.)
> 5. Hue (C vector phase adjustment)
> 6. chroma coring
> 7. chroma delay/advance in pixels relative to luma pixels
> 8. chroma subcarrier locking algorithm: fast, slow, adaptive
> 9. chroma notch filer settings (when doing Y/C separation from CVBS)
> 10. additional analog signal gain
> 11. anti-alias filter enable/disable
>
> And that's just from a quick scan of the public CX25836/7 datasheet.
>
> I left my handbook with all sorts of details about the Human Visual
> System and the CIE and NTSC and PAL colorspaces at work.

Let me rephrase my question: how would you design the user color controls?
E.g., the controls that are exported in GUIs to the average user. Most of
the controls you mentioned above are meaningless to most users. When we
have subdev device nodes, then such controls can become accessible to
applications to do fine-tuning, but they do not belong in a GUI in e.g.
tvtime or xawtv.

The problem is of course in that grey area between obviously user-level
controls like brightness and obviously (to me at least) expert-level
controls like chroma coring.

Regards,

        Hans

>
> Regards,
> Andy
>
>
>
>
>
>> Regards,
>>
>> 	Hans
>>
>> >
>> > Devin
>> >
>> >
>>
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2150 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0FGJu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 05:50:29 -0400
Message-ID: <02d98cd45620101bc64ffe6024694df3.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1006071101470.12965@axis700.grange>
References: <201005301015.59776.hverkuil@xs4all.nl>
    <19F8576C6E063C45BE387C64729E7394044E7A16AC@dbde02.ent.ti.com>
    <Pine.LNX.4.64.1006071101470.12965@axis700.grange>
Date: Mon, 7 Jun 2010 11:50:23 +0200
Subject: RE: Version 2: Tentative agenda for Helsinki mini-summit
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Mon, 7 Jun 2010, Hiremath, Vaibhav wrote:
>
>> > 14) V4L2 video output vs. framebuffer. Guennadi Liakhovetski.
>> >
>> [Hiremath, Vaibhav] Guennadi,
>>
>> Do you have anything in your mind on this? Are you preparing any slides
>> for this? Do you want me to have something from OMAP side which we can
>> use as a use-case?
>
> Yes, I will prepare some introduction, maybe a couple of slides. My
> impression is, that we shall be making all topics as short as possible,
> so, I'll try to make it concise, but I don't know exactly yet how much
> time we'd get.

Concise would be good: the first day will be packed, so I prefer to have
short presentations, and a Q&A session afterwards in case there are things
that need clarification. But I think that on Tuesday we can talk a lot
more about this. I think this is a very relevant issue for embedded
systems.

>> I can make couple of slides on this.
>
> In principle - yes, sure, I'd love you to present your use-case, but as I
> said - no idea whether we'll have time for this. So, definitely, would be
> great if you could comment on the topic, if we get time, slides would be
> great too, so, if it's not too complicated for you - please prepare them,
> but unfortunately I do not know yet whether we'll get a chance to go
> through them. In fact, I'm not quite sure how topics without an explicitly
> mentioned presentation should work - there would be some introduction in
> any case, right, Hans? Just not as long as a "proper presentation?" And
> the mentioned 10 minutes are only for the presentation, the discussion
> comes on top of that? So, I think, we should have time for your slides,
> Vaibhav, Hans can correct me if I'm wrong;)

For simple topics a presentation is overkill and you can just say what the
status and/or plan is. For more complex issues a presentation helps to
understand the problems quicker. And yes, the discussion comes on top of
the presentation.

The reason I want to keep the presentations short on Monday is that we
have some 15 topics or so to go through in, say, 7 hours. And of those 7
hours one to two hours are reserved for anything to do with memory
handling. That does not leave a lot of time for the other 14 topics.

Now, remember that on Tuesday and to a lesser extent on Wednesday we will
have more time to discuss some of these topics in more depth. And this
topic is one that deserves to be discussed more extensively. It would be
interesting to hear the views of several of the companies that have to
work with the framebuffer API: what are their experiences, ideas on how to
improve it, building a fb driver on top of a v4l driver, etc.

Regards,

        Hans




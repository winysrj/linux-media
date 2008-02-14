Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E0uQTC015565
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 19:56:26 -0500
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1E0u4d7029987
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 19:56:05 -0500
Message-ID: <47B391A1.3080904@linuxtv.org>
Date: Wed, 13 Feb 2008 19:56:01 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
References: <20080205012451.GA31004@plankton.ifup.org>	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>	<20080205080038.GB8232@plankton.ifup.org>	<20080205102409.4b7acb01@gaivota>	<20080213202055.GA26352@plankton.ifup.org>	<37219a840802131524i33e34930uc95b7a12d484526a@mail.gmail.com>
	<a728f9f90802131554y6f2c9ca1s7a8c264b46dc9a40@mail.gmail.com>
In-Reply-To: <a728f9f90802131554y6f2c9ca1s7a8c264b46dc9a40@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] Moving to git for v4l-dvb
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

Alex Deucher wrote:
> On Feb 13, 2008 6:24 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> On Feb 13, 2008 3:20 PM, Brandon Philips <bphilips@suse.de> wrote:
>>> On 10:24 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
>>>> Maybe we've took the wrong direction when we've decided to select
>>>> mercurial. It were better and easier to use, on that time, but the -git
>>>> improvements happened too fast.
>>> We should consider a move to a full-tree git.  Particularly, it would be
>>> nice to be have v4l-dvb merging/building against other subsystems in the
>>> linux-next tree:
>>>
>>>   http://lkml.org/lkml/2008/2/11/512
>>>
>>> Also, it would save the silly pain of things like this meye.h thing and
>>> pulling in fixes from the rest of the community that patches against git
>>> trees.
>>
>> When we moved from CVS to HG, we lost many developers.
>>
>> Of the developers that remain, most of us are finally comfortable
>> working in mercurial.
>>
>> I understand the benefits of moving to git, but that option was on the
>> table when we moved to mercurial from cvs, and it was shot down.
>>
>> I would prefer that we stick with what we have for now -- for the sake
>> of our users / testers, and for the sake of our developers.
>>
>> Lets not drive away more contributors.
>>
>> Additionally, the moment we move development from hg to git, we are
>> bound to the development kernel -- we will no longer be able to work
>> against any stable kernel series, and we will lose all of our testers.
> 
> Why would git have any affect on what kernels you could test against?
> It's just an scm like hg or cvs.

Alex,

You are correct.  However, it is not just the SCM in question right now.

Quoting Brandon Philips, "We should consider a move to a full-tree git"

...he is not suggesting that we simply change SCM's -- rather, he is suggesting that we work within a full kernel tree, using git, just as the other subsystems do.

This model makes sense for kernel development, but this is not exactly kernel development -- it is kernel *driver* development.

We stand to lose too much by moving to this model.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

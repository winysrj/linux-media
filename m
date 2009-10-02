Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57368 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbZJBUkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 16:40:03 -0400
Received: by bwz6 with SMTP id 6so1338260bwz.37
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2009 13:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC63EC9.2010207@rogers.com>
References: <200909252322.26427.hverkuil@xs4all.nl>
	 <4AC63EC9.2010207@rogers.com>
Date: Fri, 2 Oct 2009 22:40:06 +0200
Message-ID: <d9def9db0910021340k63492355ldb881056854b077e@mail.gmail.com>
Subject: Re: [Bulk] V4L-DVB Summit Day 3
From: Markus Rechberger <mrechberger@gmail.com>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 2, 2009 at 7:56 PM, CityK <cityk@rogers.com> wrote:
> Hans Verkuil wrote:
>> I made the following list:
>>
>> - We created a new mc mailinglist: linux-mc@googlegroups.com
>>
>> This is a temporary mailinglist where we can post and review patches during
>> prototyping of the mc API. We don't want to flood the linux-media list with
>> those patches since that is already quite high-volume.
>>
>> The mailinglist should be active, although I couldn't find it yet from
>> www.googlegroups.com. I'm not sure if it hasn't shown up yet, or if I did
>> something wrong.
>>
>
> I'm scratching my head on this one.  Seems the last thing that is needed
> is YET another mailing list.  Further, it
> - fractures the development community.

this is what I think too. I'm mainly interested in keeping up
compatibility with that framework
The traffic on this mailinglist is rather small and it should be ok to
mix up developer mails
with a few support mails (whereas people usually use to CC anyone who
might be involved anyway).

> - persons unaware of the decision, and whom might be interested, would
> never find it . i.e. alienation

if you try to send an email as adviced to that googlemail mailinglist
you'll just get an email back that it doesn't work :-)

nothing else to write about it I totally agree.

One question I have though, what is the impact to the existing API,
will they start to require that MC interface?
TI hardware is rather specialized and most other devices will not need
any of those changes, I don't see the benefit
of bloating up the API for devices which already work fine, for simple
devices it should better remain simple.
(This question is mainly because we also maintain our own player which
supports the v4l2/dvbV(3/5) API, but the
driver should still support legacy applications in the future)

Best Regards,
Markus

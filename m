Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1KCSMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 14:12:19 -0400
Message-ID: <4EB2D97E.3020600@redhat.com>
Date: Thu, 03 Nov 2011 16:12:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alain VOLMAT <alain.volmat@st.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MediaController support in LinuxDVB demux
References: <E27519AE45311C49887BE8C438E68FAA01010C61F5A6@SAFEX1MAIL1.st.com> <4EB294C9.90204@redhat.com> <E27519AE45311C49887BE8C438E68FAA01010C61F643@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01010C61F643@SAFEX1MAIL1.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-11-2011 12:05, Alain VOLMAT escreveu:
> Hi Mauro
> 
>>> During last workshop, I think we agreed that a pad would represent a
>> demux filter.
>>> My personal idea would be to have filters created via the demux
>> device node and filters accessible via MC pads totally independent.
>>> Meaning that, just as current demux, it is possible to open the demux
>> device node, create filter, set PIDs etc. Those filters have totally no
>> relation with MC pads, filters created via the demux device node are
>> just not accessible via MC pads.
>>> As far as demux MC pads are concerned, it would be possible to link a
>> pad to another entity pad (probably decoder or LinuxDVB CA) and thus
>> create a new filter in the demux. By setting the demux MC pad format
>> (not sure format is the proper term here), it would be possible to set
>> for example the PID of a filter.
>>> Internally of course all filters (MC filters and demux device node
>> filters) are all together but they are only accessible via either the
>> demux device node or the MC pad.
>>
>> We need to think a little more about that. In principle, it doesn't
>> sound a good idea
>> to me to have filters mutually exclusive to one of the API's, but maybe
>> there are
>> some implementation and/or API specific details that might force us to
>> get on this
>> direction.
> 
> The reason why I propose to have mutex mutually exclusive is that I think it is hard to figure out the relation between a file handle and a PAD.
> Meaning, you could open the demux device file, then create a filter and set a PID for instance but how would you figure out which pad is corresponding to the filter you've just created via the demux device file. Having MC filters and demux device node filter separately also help not to break existing LinuxDVB demux API.

On the other hand, we'll have troubles with existing applications if this is not implemented.
So, we'll need anyway to associate a PID filter with a DVBv5 call. At V4L, this will be solved
via v4l-utils. We probably need to discuss it better for DVB.


> 
>> So, I'd say that we should try to write a patch for it first, trying to
>> allow
>> setting it via both API's and then discuss about implementation-
>> specific issues,
>> if this is not feasible, or would be very messy.
> 
> Currently, of drivers integrated in upstream linux, I guess that only the av7110 driver (too old right) is actually having the demux output pushed to something other than user land right ? (in this case the decoder). Implementing MC support for the kernel demux driver would be possible I think but probably not really meaningful since having pads wouldn't help much ...

Yes, only av7110 uses it. Well, let's first add MC support to DVB. We can take care
of the details like that when we'll have something coded.

> Regards,
> 
> Alain
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥


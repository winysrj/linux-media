Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59196 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0EPBdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 21:33:14 -0400
Received: by vws9 with SMTP id 9so1012626vws.19
        for <linux-media@vger.kernel.org>; Sat, 15 May 2010 18:33:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005160106.56028@orion.escape-edv.de>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
	 <201004211144.19591@orion.escape-edv.de>
	 <201005160106.56028@orion.escape-edv.de>
Date: Sat, 15 May 2010 22:33:12 -0300
Message-ID: <AANLkTimRAmxOL_eilVew3E9cabznR0_H2QZsvAXWM-bk@mail.gmail.com>
Subject: Re: av7110 and budget_av are broken!
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: linux-media@vger.kernel.org
Cc: Douglas Schilling Landgraf <dougsland@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Oliver,

On Sat, May 15, 2010 at 8:06 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> On Wednesday 21 April 2010 11:44:16 Oliver Endriss wrote:
>> On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
>> > > Am 22.3.2010 20:34, schrieb e9hack:
>> > >> Am 20.3.2010 22:37, schrieb Hans Verkuil:
>> > >>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
>> > >>> OK, I know that. But does the patch I mailed you last time fix this
>> > >>> problem
>> > >>> without causing new ones? If so, then I'll post that patch to the list.
>> > >>
>> > >> With your last patch, I've no problems. I'm using a a TT-C2300 and a
>> > >> Budget card. If my
>> > >> VDR does start, currently I've no chance to determine which module is
>> > >> load first, but it
>> > >> works. If I unload all modules and load it again, I've no problem. In
>> > >> this case, the
>> > >> modules for the budget card is load first and the modules for the FF
>> > >> loads as second one.
>> > >
>> > > Ping!!!!!!
>> >
>> > It's merged in Mauro's fixes tree, but I don't think those pending patches
>> > have been pushed upstream yet. Mauro, can you verify this? They should be
>> > pushed to 2.6.34!
>>
>> What about the HG driver?
>> The v4l-dvb HG repository is broken for 7 weeks...
>
> Hi guys,
>
> we have May 16th, and the HG driver is broken for 10 weeks now!
>
> History:
> - The changeset which caused the mess was applied on March 2nd:
>  http://linuxtv.org/hg/v4l-dvb/rev/2eda2bcc8d6f
>
> - A fix is waiting at fixes.git since March 24th:
>  http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
>
> Are there any plans to bring v4ldvb HG to an usable state?

Yes, Now I will collect patches from devel and fixes tree. At least
until we achieve a better approach on it.
Sorry the delay.

Sounds good? Any other suggestion?

Let me work on it.

Cheers
Douglas

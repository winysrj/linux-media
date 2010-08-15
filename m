Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51956 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0HOR5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Aug 2010 13:57:36 -0400
Received: by iwn7 with SMTP id 7so844432iwn.19
        for <linux-media@vger.kernel.org>; Sun, 15 Aug 2010 10:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
	<AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
	<4C581BB6.7000303@redhat.com>
	<AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
	<AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com>
	<AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
Date: Sun, 15 Aug 2010 14:57:35 -0300
Message-ID: <AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
Subject: Re: V4L hg tree fails to compile against latest stable kernel 2.6.35
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello Derek,

On Sun, Aug 15, 2010 at 2:22 AM, Douglas Schilling Landgraf
<dougsland@gmail.com> wrote:
> Hello Derek,
>
> On Sat, Aug 14, 2010 at 12:46 PM, VDR User <user.vdr@gmail.com> wrote:
>> On Wed, Aug 4, 2010 at 10:19 PM, Douglas Schilling Landgraf
>> <dougsland@gmail.com> wrote:
>>> I am already working to give a full update to hg tree. Sorry this problem.
>>
>> Hi Douglas.  Any estimate when this will be fixed?  Was hoping it was
>> already since new stable kernel 2.6.35.2 is out now but still the same
>> problem when I tried just now.
>
> I am already working on it this weekend. I will reply this thread when finished.

2.6.35 should be working, let me know if not. Now, I need to backport
the changes to old kernels
and commit other patches in my pending list.

Cheers
Douglas

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34112 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0HEFo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 01:44:58 -0400
Received: by yxg6 with SMTP id 6so2356077yxg.19
        for <linux-media@vger.kernel.org>; Wed, 04 Aug 2010 22:44:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
	<AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
	<4C581BB6.7000303@redhat.com>
	<AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
Date: Wed, 4 Aug 2010 22:44:55 -0700
Message-ID: <AANLkTi=KQPhNgYvCbwNaOqW+k73uYcfaHYAj_N2Yvmvn@mail.gmail.com>
Subject: Re: V4L hg tree fails to compile against latest stable kernel 2.6.35
From: VDR User <user.vdr@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 4, 2010 at 10:19 PM, Douglas Schilling Landgraf
<dougsland@gmail.com> wrote:
> Hello Derek,
>
> On Tue, Aug 3, 2010 at 10:37 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 03-08-2010 03:44, VDR User escreveu:
>>> On Mon, Aug 2, 2010 at 11:36 PM, VDR User <user.vdr@gmail.com> wrote:
>>>> Any idea when this will be fixed?
>>
>> It is up to Douglas to do the backport, but you can just use the latest
>> git tree, where those patches are applied already at 2.6.35, at the
>> branch staging/v2.6.36.
>
> I am already working to give a full update to hg tree. Sorry this problem.

Hi Douglas, thanks for the update!  I'll pass the word along to other
users I know who are wondering as well but who don't use the mailing
list.

A little off topic but IIRC wasn't there some talk about writing new
scripts to main keep hg more up-to-date?  If so, was that ever
started?  Otherwise, my apologies if I'm not remembering correctly.

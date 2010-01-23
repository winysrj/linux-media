Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46566 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab0AWCSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 21:18:10 -0500
Received: by fxm20 with SMTP id 20so1978009fxm.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 18:18:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5A0B92.1020404@infradead.org>
References: <201001180106.30373.liplianin@me.by>
	 <4B5A0B92.1020404@infradead.org>
Date: Sat, 23 Jan 2010 00:18:08 -0200
Message-ID: <68cac7521001221818g7a0cd947r5390192e7842c5d1@mail.gmail.com>
Subject: Re: [PATCH] http://mercurial.intuxication.org/hg/v4l-dvb-commits
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	JD Louw <jd.louw@mweb.co.za>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Jan 22, 2010 at 6:33 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Igor M. Liplianin wrote:
>> Mauro,
>>
>> Please pull from http://mercurial.intuxication.org/hg/v4l-dvb-commits
>>
>> for the following 5 changesets:
>>
>> 01/05: Add Support for DVBWorld DVB-S2 PCI 2004D card
>> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=199213295c11
>>
>> 02/05: Compro S350 GPIO change
>> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=84347195a02c
>>
>> 03/05: dm1105: connect splitted else-if statements
>> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=cd9e72ee99c4
>>
>> 04/05: dm1105: use dm1105_dev & dev instead of dm1105dvb
>> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=5cb9c8978917
>>
>> 05/05: dm1105: use macro for read/write registers
>> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=6ed71bd9d32b
>>
>>
>>  dvb/dm1105/Kconfig            |    1
>>  dvb/dm1105/dm1105.c           |  539 +++++++++++++++++++++---------------------
>>  video/saa7134/saa7134-cards.c |    4
>>  3 files changed, 285 insertions(+), 259 deletions(-)
>>
>
> applied on -git, thanks.
>

Applied on -hg tree, thanks!

Cheers,
Douglas

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35828 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbFWHuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 03:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <20150622211857.GY7557@n2100.arm.linux.org.uk>
References: <1435006096-12470-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdXprKyxirhUZBzNV97oxymcMqeugKixTEC8ojcMq3EeDw@mail.gmail.com>
	<20150622211857.GY7557@n2100.arm.linux.org.uk>
Date: Tue, 23 Jun 2015 09:50:00 +0200
Message-ID: <CAMuHMdXyaS65sTdkB88btchm5NzwgNK969QNcaoGBj9-77eFXQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v4.1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Mon, Jun 22, 2015 at 11:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 22, 2015 at 10:52:13PM +0200, Geert Uytterhoeven wrote:
>> On Mon, Jun 22, 2015 at 10:48 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > JFYI, when comparing v4.1[1] to v4.1-rc8[3], the summaries are:
>> >   - build errors: +44/-7
>>
>>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
>> 'L_PTE_MT_BUFFERABLE' undeclared here (not in a function):  => 81:10
>>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
>> 'L_PTE_MT_DEV_CACHED' undeclared here (not in a function):  => 117:10
>>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
>> 'L_PTE_MT_DEV_NONSHARED' undeclared here (not in a function):  =>
>> 108:10
>
> I'm rather ignoring this because I don't see these errors here.  This
> is one of the problems of just throwing out build reports.  With zero
> information such as a configuration or a method on how to cause the
> errors, it's pretty much worthless to post errors.
>
> Folk who do build testing need to be smarter, and consider what it's
> like to be on the receiving end of their report emails...

Fortunately the kisskb service has good bookkeeping of build logs and configs.

Re-adding the lost URL:
>> [1] http://kisskb.ellerman.id.au/kisskb/head/9038/ (all 254 configs)

  1. Open URL in web browser,
  2. Click on "Failed", next to "arm-randconfig",
  3. Click on "Download", next to "arm-randconfig",
  4. Reproduce,
  5. Fix,
  6. Profit! ;-)

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

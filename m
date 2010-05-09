Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0EITqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:46:24 -0400
Received: by fxm10 with SMTP id 10so1851822fxm.19
        for <linux-media@vger.kernel.org>; Sun, 09 May 2010 12:46:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273431979.4779.786.camel@alkaloid.netup.ru>
References: <1273135577.16031.11.camel@plop>
	 <1273431979.4779.786.camel@alkaloid.netup.ru>
Date: Sun, 9 May 2010 23:46:23 +0400
Message-ID: <AANLkTimh8O8Y0Jqaskohqam47UNoG2Efoy3IEo3DZuqB@mail.gmail.com>
Subject: Re: stv090x vs stv0900
From: Manu Abraham <abraham.manu@gmail.com>
To: Abylai Ospan <aospan@netup.ru>
Cc: Pascal Terjan <pterjan@mandriva.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 9, 2010 at 11:06 PM, Abylai Ospan <aospan@netup.ru> wrote:
> Hello,
>
> On Thu, 2010-05-06 at 10:46 +0200, Pascal Terjan wrote:
>> Also, are they both maintained ? I wrote a patch to add get_frontend to
>> stv090x but stv0900 also does not have it and I don't know which one
>> should get new code.
>
> I have added get_frontend to stv0900 two months ago -
> http://linuxtv.org/hg/v4l-dvb/rev/a3e28fbefdc3
>
> I'm trying to describe my point of view about two drivers for stv6110
> +stv0900.
>
> History:
> I have anounced our card on November 2008 -
> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030439.html
> As you can see I have mentioned that we developing code and will be
> publish it under GPL. All people in ML received this message. This
> should be prevent of duplicate work.
> Also we have obtained permission (signed letter) from STM to publish
> resulting code under GPL. We have send pull request at Feb 2009 -
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg02180.html
>
> (stv090x commit requested later - in May 2009 -
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg04978.html ).
>
>
> Solution:
> Ideally two drivers should be combined into one. stv0900 driver can be
> used as starting point. We (NetUP Inc.) can initiaite this job. But we
> need approval from Manu and all community who using stv090x. Manu what
> do you think about this ?


The STV090x driver supports both the STV0900 and STV0903 broadcast
demodulators very well and in multiple configurations on couple of
bridges (SAA7146, nGene, SAA7160, some USB bridges, some others also
in the process) and is quite a generic one. Currently, the STV090x
driver handles a lot of quirks which has been documented as well as
undocumented by STM, basically being actively supported by STM
themselves and by a few card vendors as well, other than for this
community to a very great extend.

Currently, since the driver has been fine tuned to this great extend
and so many users of it, I have no plans of migrating to the STV0900
driver, which was developed later on and tested to a much lesser
extend, by developers and vendors alike. So, I am much less inclined
to go the STV0900 way.

At the behest of STM themselves, I have withheld from adding support
for the AAB/AAC chips initially, due to the basic reasons that these
advanced features are not really well tested in the field, due to the
lack of that many users and the highly unlikely chance that the
advanced stuff (ACM/VCM) is yet to be deployed for a home user
segment. In the chance that there are more likely users for the
advanced stuff, these can be added quite easily to the
STV090x/STV6110x driver.

Also, interesting point to be noted is that there are no users for
ACM/VCM in the Linux userspace for the driver to be supported for
"any" broadcast purposes. The only case in where the Advanced chips
are being sold (that too at a higher price) is where card
manufacturers who cannot commit themselves to that volume, not that it
adds any value to the general user as it is, at the this time. Simply
adding in code and making it unmaintainable makes no sense to me at
least.

Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:44522 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1ELLNh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 07:13:37 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QKTpm-00006H-Kh
	for linux-media@vger.kernel.org; Thu, 12 May 2011 13:13:34 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 12 May 2011 13:13:34 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 12 May 2011 13:13:34 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: dvb-core/dvb_frontend.c: Synchronizing legacy and new tuning API
Date: Thu, 12 May 2011 13:13:21 +0200
Message-ID: <87aaesb29a.fsf@nemi.mork.no>
References: <87sjslaxwz.fsf@nemi.mork.no> <4DCAEED2.6040906@linuxtv.org>
	<87oc38bdsf.fsf@nemi.mork.no>
	<BANLkTinqjMYEkZc4-+rAgfb952_NnCNYkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

HoP <jpetrous@gmail.com> writes:
> 2011/5/12 Bjørn Mork <bjorn@mork.no>:
>> Andreas Oberritter <obi@linuxtv.org> writes:
>>
>>> Please try the patches submitted for testing:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg31194.html
>>
>> Ah, great! Thanks.  Nothing better than a problem already solved.
>
> Not solved. Andreas did an attempt to solve it (at least as far as I know
> patches not get accepted yet), so please report your result of testing.

Sure. 

Now, the only machine I've got with DVB cards is running a stock Debian
2.6.32 kernel and I prefer not to mess with that.  But I did a
quick-n-dirty "backport" of the API changes to 2.6.32, built a new
dvb_core module and loaded that.  And the results are good, as
expected.  All parameters are now in sync.  

Both these adapters have been tuned by VDR (which uses the new API):


bjorn@canardo:/usr/local/src/git/linux-2.6$ /tmp/dvb_fe_test /dev/dvb/adapter0/frontend0 
== /dev/dvb/adapter0/frontend0 ==
name: Philips TDA10023 DVB-C
type: FE_QAM

== FE_GET_FRONTEND ==
frequency     : 264006739
inversion     : off (0)
symbol_rate   : 6900000
fec_inner     : FEC_NONE (0)
modulation    : QAM_256 (5)

== FE_GET_PROPERTY ==
[17] DTV_DELIVERY_SYSTEM : SYS_DVBC_ANNEX_AC (1)
[03] DTV_FREQUENCY       : 264006739
[06] DTV_INVERSION       : off (0)
[08] DTV_SYMBOL_RATE     : 6900000
[09] DTV_INNER_FEC       : FEC_NONE (0)
[04] DTV_MODULATION      : QAM_256 (5)
[35] DTV_API_VERSION     : 5.1
[05] DTV_BANDWIDTH_HZ    : BANDWIDTH_AUTO (3)

bjorn@canardo:/usr/local/src/git/linux-2.6$ /tmp/dvb_fe_test /dev/dvb/adapter1/frontend0 
== /dev/dvb/adapter1/frontend0 ==
name: Philips TDA10023 DVB-C
type: FE_QAM

== FE_GET_FRONTEND ==
frequency     : 272006739
inversion     : off (0)
symbol_rate   : 6900000
fec_inner     : FEC_NONE (0)
modulation    : QAM_256 (5)

== FE_GET_PROPERTY ==
[17] DTV_DELIVERY_SYSTEM : SYS_DVBC_ANNEX_AC (1)
[03] DTV_FREQUENCY       : 272006739
[06] DTV_INVERSION       : off (0)
[08] DTV_SYMBOL_RATE     : 6900000
[09] DTV_INNER_FEC       : FEC_NONE (0)
[04] DTV_MODULATION      : QAM_256 (5)
[35] DTV_API_VERSION     : 5.1
[05] DTV_BANDWIDTH_HZ    : BANDWIDTH_AUTO (3)




I've obviously messed up the API_VERSION, so this is probably more
dirty than quick....  But all the important values, like frequency,
inversion and inner_fec, are now in sync.

Thanks a lot.  Feel free to add 

   Tested-by: Bjørn Mork <bjorn@mork.no>

to the whole patch series if that matters to anyone.  I'd really like
this to go into 2.6.40 if that is possible. It would have been nice to
see it in 2.6.32-longerm was well, but I guess that's out of the
question since it builds on top of other API changes (DVBT2).



Bjørn


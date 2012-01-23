Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab2AWUf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 15:35:26 -0500
Message-ID: <4F1DC483.3070203@redhat.com>
Date: Mon, 23 Jan 2012 18:35:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.4] [media] cxd2820r: fix dvb_frontend_ops
References: <E1RpQFN-0000uK-Bc@www.linuxtv.org> <4F1DC03D.4080204@iki.fi>
In-Reply-To: <4F1DC03D.4080204@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 18:17, Antti Palosaari escreveu:
> Are going to push these Kernel 3.4 as topic hints?
> These are fixes for 3.3, for example that patch in question...

Those patches are on my queue for 3.3. I'll now be adding the fixes
also to the current branch, in order to allow them to be tested by
a broader audience, before sending upstream.

commit c79eba92406acc4898adcd1689fc21a6aa91ed0b
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Jan 23 13:15:22 2012 -0200

    [media] cinergyT2-fe: Fix bandwdith settings
    
    Changeset 7830bbaff9f mangled the bandwidth field for CinergyT2.
    Properly fill it.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 03652e0ad4b140523ec5ef7fec8d2b3c7218447b
Author: Josh Wu <josh.wu@atmel.com>
Date:   Wed Jan 11 00:58:29 2012 -0300

    [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
    
    Signed-off-by: Josh Wu <josh.wu@atmel.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 72565224609a23a60d10fcdf42f87a2fa8f7b16d
Author: Antti Palosaari <crope@iki.fi>
Date:   Fri Jan 20 19:48:28 2012 -0300

    [media] cxd2820r: sleep on DVB-T/T2 delivery system switch
    
    Fix bug introduced by multi-frontend to single-frontend change.
    It is safer to put DVB-T parts sleeping when auto-switching to DVB-T2
    and vice versa. That was original behaviour.
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 46de20a78ae4b122b79fc02633e9a6c3d539ecad
Author: Antti Palosaari <crope@iki.fi>
Date:   Fri Jan 20 17:39:17 2012 -0300

    [media] anysee: fix CI init
    
    No more error that error seen when device is plugged:
    dvb_ca adapter 0: Invalid PC card inserted :(
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit c2bbbe7b5e79974c5ed1c828690731f6f5106bee
Author: Antti Palosaari <crope@iki.fi>
Date:   Thu Jan 19 14:46:43 2012 -0300

    [media] cxd2820r: remove unused parameter from cxd2820r_attach
    
    Fix bug introduced by multi-frontend to single-frontend change.
    This parameter is no longer used after multi-frontend to single-frontend change.
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 9bf31efa84c898a0cf294bacdfe8edcac24e6318
Author: Antti Palosaari <crope@iki.fi>
Date:   Wed Jan 18 13:57:33 2012 -0300

    [media] cxd2820r: fix dvb_frontend_ops
    
    Fix bug introduced by multi-frontend to single-frontend change.
    
    * Add missing DVB-C caps
    * Change frontend name as single frontend does all the standards
    
    Signed-off-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


Regards,
Mauro.
> 
> Antti
> 
> On 01/23/2012 10:10 PM, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] cxd2820r: fix dvb_frontend_ops
>> Author:  Antti Palosaari<crope@iki.fi>
>> Date:    Wed Jan 18 13:57:33 2012 -0300
>>
>> Fix bug introduced by multi-frontend to single-frontend change.
>>
>> * Add missing DVB-C caps
>> * Change frontend name as single frontend does all the standards
>>
>> Signed-off-by: Antti Palosaari<crope@iki.fi>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>>   drivers/media/dvb/frontends/cxd2820r_core.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> ---
>>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=9bf31efa84c898a0cf294bacdfe8edcac24e6318
>>
>> diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
>> index caae7f7..5fe591d 100644
>> --- a/drivers/media/dvb/frontends/cxd2820r_core.c
>> +++ b/drivers/media/dvb/frontends/cxd2820r_core.c
>> @@ -562,7 +562,7 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
>>       .delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
>>       /* default: DVB-T/T2 */
>>       .info = {
>> -        .name = "Sony CXD2820R (DVB-T/T2)",
>> +        .name = "Sony CXD2820R",
>>
>>           .caps =    FE_CAN_FEC_1_2            |
>>               FE_CAN_FEC_2_3            |
>> @@ -572,7 +572,9 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
>>               FE_CAN_FEC_AUTO            |
>>               FE_CAN_QPSK            |
>>               FE_CAN_QAM_16            |
>> +            FE_CAN_QAM_32            |
>>               FE_CAN_QAM_64            |
>> +            FE_CAN_QAM_128            |
>>               FE_CAN_QAM_256            |
>>               FE_CAN_QAM_AUTO            |
>>               FE_CAN_TRANSMISSION_MODE_AUTO    |
> 
> 


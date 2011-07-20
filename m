Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1GTUJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 16:09:20 -0400
Message-ID: <4E2735EB.70606@infradead.org>
Date: Wed, 20 Jul 2011 17:09:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Abylay Ospan <aospan@netup.ru>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] NetUP Dual DVB-T/C CI RF card
References: <4E23ED1C.7070609@netup.ru> <4E2708B3.50004@netup.ru>
In-Reply-To: <4E2708B3.50004@netup.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Abylay,

Em 20-07-2011 13:56, Abylay Ospan escreveu:
> Hi Mauro,
> 
> Here is more correct pull request. URL now is git://git.netup.tv/git/linux-3.0-netup.git.
> 
> 
> The following changes since commit f560f6697f17e2465c8845c09f3a483faef38275:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2011-07-17 12:49:55 -0700)
> 
> are available in the git repository at:
> 
>   git://git.netup.tv/git/linux-3.0-netup.git netup-fw

Could you please also prepare a patch moving altera-stapl to drivers/misc? 

Thanks!
Mauro 

> 
> Abylay Ospan (3):
>       NetUP Dual DVB-T/C CI RF: load firmware according card revision
>       Don't fail if videobuf_dvb_get_frontend return NULL
>       NetUP Dual DVB-T/C CI RF: force card hardware revision by module param
> 
>  drivers/media/video/cx23885/cx23885-cards.c |   21 +++++++++++++++++++++
>  drivers/media/video/cx23885/cx23885-dvb.c   |    2 +-
>  2 files changed, 22 insertions(+), 1 deletions(-)
> 
> 
> 
> On 18.07.2011 12:21, Abylay Ospan wrote:
>> Hi Mauro,
>>
>> Please pull 3 changes from http://stand.netup.tv/gitweb/?p=linux-3.0-netup;a=summary
>>
>> Thanks!
>>
>>
>> The following changes since commit f560f6697f17e2465c8845c09f3a483faef38275:
>>
>>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2011-07-17 12:49:55 -0700)
>>
>> are available in the git repository at:
>>
>>   http://stand.netup.tv/gitweb/?p=linux-3.0-netup netup_fw
>>
>> Abylay Ospan (3):
>>       NetUP Dual DVB-T/C CI RF: load firmware according card revision
>>       Don't fail if videobuf_dvb_get_frontend return NULL
>>       NetUP Dual DVB-T/C CI RF: force card hardware revision by module param
>>
>>  drivers/media/video/cx23885/cx23885-cards.c |   21 +++++++++++++++++++++
>>  drivers/media/video/cx23885/cx23885-dvb.c   |    2 +-
>>  2 files changed, 22 insertions(+), 1 deletions(-)
>>
>>
> 


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2FZSXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 14:23:19 -0400
Message-ID: <4FE9FE14.70804@redhat.com>
Date: Tue, 26 Jun 2012 15:23:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/12] saa7164: Use i2c_rc properly to store i2c register
 status
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com> <4FE8BC2D.9030902@redhat.com> <CALF0-+UyWjbbPYCKV-AgS=6FZ349D27GrijrYa_RWPUqcfo8rw@mail.gmail.com> <4FE8C0E0.3080104@redhat.com> <CALF0-+V_NCb2TMdd9SS-jrPKS8ocWRNAvwo1-ptPCW2GtNZEkw@mail.gmail.com> <4FE8CFAC.20302@redhat.com> <CALF0-+VDcVLzRjcrLzyquqSFoN5G-QF6GjaNpdVhbamRsRbA7w@mail.gmail.com>
In-Reply-To: <CALF0-+VDcVLzRjcrLzyquqSFoN5G-QF6GjaNpdVhbamRsRbA7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 13:40, Ezequiel Garcia escreveu:
> Mauro,
> 
> On Mon, Jun 25, 2012 at 5:53 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>
>> Yeah, research is needed ;) As "bttv" is the mother of the I2C code found at
>> other PCI drivers, as it is one of the oldest implementations, I bet you'll
>> find this field propagated without usage on some drivers (and probably other
>> unused fields as well ;) )
>>
> 
> I did some research and it looks like this patch series should be broke in two:
> - cleanup i2c_rc and i2c unused stuff
> - struct i2c_algo_bit_data cleanup (already sent)
> 
> Unless there is some problem with the latter, could you pick this patches:
> (i.e, the whole series except the i2c_rc part)
>   cx25821: Replace struct memcpy with struct assignment
>   cx25821: Remove useless struct i2c_algo_bit_data usage
>   cx231xx: Replace struct memcpy with struct assignment
>   cx231xx: Remove useless struct i2c_algo_bit_data usage
>   cx23885: Replace struct memcpy with struct assignment
>   cx23885: Remove useless struct i2c_algo_bit_data
>   saa7164: Replace struct memcpy with struct assignment
>   saa7164: Remove useless struct i2c_algo_bit_data
> 
>   I'll fix a new patch series for i2c_rc cleaning.
> 
> Hope this is not too much trouble for you.

I prefer if you could re-send them with a proper description why
i2c_rc is needed. Only really really trivial emails may not
have descriptions ;)

> Thanks,
> Ezequiel.
> 



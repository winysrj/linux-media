Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Ky4Ry-0007V6-C4
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 13:59:03 +0100
Received: from localhost.localdomain (unknown [127.0.0.1])
	by a-sasl-fastnet.sasl.smtp.pobox.com (Postfix) with ESMTP id
	DB1D679DBA
	for <linux-dvb@linuxtv.org>; Thu,  6 Nov 2008 07:58:17 -0500 (EST)
Received: from [192.168.1.12] (unknown [118.208.2.50]) (using TLSv1 with
	cipher AES128-SHA (128/128 bits)) (No client certificate requested) by
	a-sasl-fastnet.sasl.smtp.pobox.com (Postfix) with ESMTPSA id 0D2D179DB8
	for <linux-dvb@linuxtv.org>; Thu,  6 Nov 2008 07:58:15 -0500 (EST)
Message-Id: <F5E23E92-61F6-4A23-A7AA-4F0F9E502793@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1225968119.5453.43.camel@ip6-localhost>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 6 Nov 2008 22:57:58 +1000
References: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
	<4912BA94.8060809@kipdola.com> <1225968119.5453.43.camel@ip6-localhost>
Subject: Re: [linux-dvb] dvbloopback:
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On 6 Nov 2008, at 20:41, Per Heldal wrote:

> On Thu, 2008-11-06 at 10:36 +0100, Jelle De Loecker wrote:
>> In my case it must be an S2API thing, because when I was using
>> Multiproto everything worked fine.
>>
>> Or maybe it's a regression in the latest revision (r53?) I should  
>> find
>> out ...
>
> dvbloopback copies a number of functions from the dvb source which
> aren't exported through the API of which some may have been altered,  
> nor
> is it afics prepared to carry the additional tuning attributes. It is
> thus a fair assumption that it may need a bit of attention to fully
> support tuning via DVB-API v5.


Using the hg sources from around end of September fixed the problem  
for me.

I guess dvbloopback would need to be updated to current DVB v5 with  
S2API support eventually..

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

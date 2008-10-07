Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KnFuj-0002u6-Gl
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 19:00:03 +0200
Message-ID: <48EB956D.9010900@gmail.com>
Date: Tue, 07 Oct 2008 20:59:25 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Jaap Crezee <jaap@jcz.nl>
References: <44838.194.48.84.1.1223383227.squirrel@webmail.dark-green.com>
	<48EB5A9D.1090609@jcz.nl>
In-Reply-To: <48EB5A9D.1090609@jcz.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API vs Multiproto vs TT 3200
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

Jaap Crezee wrote:
> Hello everyone,
> 
> gimli wrote:
>> Hi All,
>>
> 
> <snip>
> 
>> was made. Please cool down and bring the pieces together to give the
>> user the widest driver base and support for S2API.
> 
> With this in mind, I would like to work on porting the TT S2-3200 driver stuff to S2API. I have done a little bit of 
> research and found out that it is hard to find what the differences are between both API's on a source/technical level.
> Can anyone offer some insight into differences or give some starting point (or maybe even an example) of how to port 
> Multiproto drivers to the S2API?
> 
> I own a TT S2-3200 card and would like to see it supported by kernel.org vanille kernel... For now, everything works 
> fine (Scanning, tuning, CAM module, Diseq), except I haven't tried S2 channels yet.

I do plan to have a port of the STB0899 + STV090x. The reason why i do
say a port and still maintain multiproto: S2API is incapable of handling
DVB-S2 ACM (with 16/32APSK) as it is, ie, doesn't support DVBFE_GET_INFO
for notification of MODCOD changes.

Similar to a patch that i had posted for handling diversity some days? back.

With regards to the cx24116, this is of no concern as it doesn't support
16/32APSK in any event.

Or is there any bugfix to S2API which updates the DVBFE_GET_EVENT ioctl ?


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

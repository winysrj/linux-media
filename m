Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rtp-iport-1.cisco.com ([64.102.122.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obardenh@cisco.com>) id 1JUlbx-00048g-G7
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 17:27:57 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Thu, 28 Feb 2008 17:27:00 +0100
Message-ID: <7FA4B8777C810C4B8F3ABBB47DF0F375064C55EA@xmb-ams-332.emea.cisco.com>
In-Reply-To: <47C6D8D0.5060107@iki.fi>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com><47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com><47C1764C.5070103@otenet.gr>	<47C1AFC1.7050704@otenet.gr><47C19735.4030601@gmail.com>	<47C1D52B.6070906@otenet.gr><47C1C55F.5030406@gmail.com>	<47C32947.1030604@otenet.gr><47C33CB1.1080502@gmail.com>	<47C49F79.1080704@otenet.gr><47C48845.4030808@gmail.com><7FA4B8777C810C4B8F3ABBB47DF0F375064C4A7B@xmb-ams-332.emea.cisco.com><47C64FB0.3020201@iki.fi><7FA4B8777C810C4B8F3ABBB47DF0F375064C510B@xmb-ams-332.emea.cisco.com>
	<47C6D8D0.5060107@iki.fi>
From: "Oliver Bardenheier (obardenh)" <obardenh@cisco.com>
To: "Seppo Ingalsuo" <seppo.ingalsuo@iki.fi>, <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] STB0899 users,
	please verify results was Re: TechniSat SkyStar HD:
	Problems	scaning and zaping
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

No problem,  :-)

You just check out the tree via the webpage:
http://jusst.de/hg/multiproto

then click on the needed changeset
http://jusst.de/hg/multiproto/rev/0448e5a6d8a6 

and download the bzip with the complete changeset
http://jusst.de/hg/multiproto/archive/0448e5a6d8a6.tar.bz2

The rest is routine....     :-)

Oliver


-----Original Message-----
From: linux-dvb-bounces@linuxtv.org
[mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Seppo Ingalsuo
Sent: Donnerstag, 28. Februar 2008 16:53
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 users, please verify results was Re:
TechniSat SkyStar HD: Problems scaning and zaping

Oliver Bardenheier (obardenh) wrote:
>  Seppo, You should use the group-mailer linux-dvb@linuxtv.org
>   
Sorry Olivier, I didn't mean to send you personal email!

I still have the same problem and I'm not familiar with various DVB
driver sources discussed here (hg-tree, mantis). As I suppose I have the
same issue as discussed in this thread, how do I retrieve an older
version of the driver for TT S2-3200 that would work?

BR,
Seppo

> regards
> Oliver
>
> -----Original Message-----
> From: Seppo Ingalsuo [mailto:seppo.ingalsuo@iki.fi]
> Sent: Donnerstag, 28. Februar 2008 07:08
> To: Oliver Bardenheier (obardenh)
> Subject: Re: [linux-dvb] STB0899 users, please verify results was Re:
> TechniSat SkyStar HD: Problems scaning and zaping
>
> Oliver Bardenheier (obardenh) wrote:
>   
>> I can confirm that current hg-tree breaks SkyStarHD. Mostly unusable,

>> many transponders not working.
>> I changed back to  45eec532cefa  and everything is working fine.
>>   
>>     
> I'm using multiproto-74c6c2ee613b grabbed yesterday and I was able to 
> see only BBC World from Astra 19.2E. Other channels I tried to zap to 
> didn't work. Also there seemed to be problems in driving reliably 
> diseqc positioner (that the old TT budget-s handled fine).
>
> It was my first experience with brand new TT S2-3200 and vdr 1.5.16 
> with Reinhard's H.264 patch set.
>
> BR,
> Seppo
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

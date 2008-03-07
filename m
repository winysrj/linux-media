Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dunedin.prolingua.co.uk ([82.68.7.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dm@prolingua.co.uk>) id 1JXdGi-0004S9-2s
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 15:09:54 +0100
Received: from [192.168.1.155] (danae.prolingua.co.uk [192.168.1.155])
	by dunedin.prolingua.co.uk (8.13.8/8.13.8/Debian-3) with ESMTP id
	m27E9FFs026631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Fri, 7 Mar 2008 14:09:16 GMT
Message-ID: <47D14C71.5040400@prolingua.co.uk>
Date: Fri, 07 Mar 2008 14:08:49 +0000
From: David Matthews <dm@prolingua.co.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <47D0EA5B.8040105@philpem.me.uk>
In-Reply-To: <47D0EA5B.8040105@philpem.me.uk>
Subject: Re: [linux-dvb] Updated scan file for uk-EmleyMoor
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

Philip Pemberton wrote:
> Here's a scan file for Emley Moor with the correct frequencies and tuning 
> parameters... Seems the one in the linux-dvb distribution has frequencies with 
> a -133kHz or so offset, and without the correct QAM parameters. Probably my 
> fault, because IIRC I submitted that tuning file...
> 
> Data sourced from www.ukfree.tv, and works fine on my HVR-3000.
> 
> # Emley Moor, West Yorkshire
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 626000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
> T 650000000 8MHz 2/3 3/4 QAM64 2k 1/32 NONE
> T 674000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 698000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 706000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE
> T 722000000 8MHz 3/4 3/4 QAM16 2k 1/32 NONE

Have you looked at the Ofcom site?  You may find that the current 
frequencies are actually correct.  Apparently all the transmitters at 
Emley Moor have a 166kHz offset, either + or - depending on the channel.
See 
http://www.ofcom.org.uk/static/reception_advice/dtt_pocket_guide_3_0.pdf 
which lists all the UK transmitters and their offsets.

www.ukfree.tv seems to ignore the offset and just include the base 
channel number.  Generally it doesn't matter since the bandwidth of the 
tuner will be more than sufficient.  Of course, it would be a good idea 
to fix the QAM parameters if they're wrong.

David

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

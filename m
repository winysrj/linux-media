Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JdwGs-0007qL-6E
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 00:40:06 +0100
Message-ID: <47E83BB7.6020209@iki.fi>
Date: Tue, 25 Mar 2008 01:39:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mark Spieth <mark@digivation.com.au>
References: <006d01c88e06$25cb0830$a101a8c0@sigtec.com.au>
In-Reply-To: <006d01c88e06$25cb0830$a101a8c0@sigtec.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] best mxl500x repo
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

moikka,

Mark Spieth wrote:
> hi
> 
> which is the best mxl500x repo to use, manu or stoth?

Both trees are same, Manu's tree has only two minor cosmetic changes more.

> I have a kworld dual plus 399U afatech which uses this tuner and I want to 
> merge the mxl500x tuner into the anttip repo.

Cool. I will help as much as possible. Your device is dual tuner and 
this tree supports currently only one tuner. Getting one tuner to work 
should be really easy task. Adding support for second tuner needs some 
hacking. Can you take some usb-sniffs that I can analyze it a little?

> I assume this is the best af9015 repo to use as opposed to zoltech or manu.
> USB ID is 1B80:E399
> 
> thanks
> mark 

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
